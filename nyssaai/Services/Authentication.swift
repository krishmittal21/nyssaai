//
//  AuthenticationState.swift
//  nyssaai
//
//  Created by Krish Mittal on 26/03/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationError: Error {
  case tokenError(message: String)
}

@Observable
@MainActor
class Authentication {
  var name = ""
  var email = ""
  var password = ""
  var confirmPassword = ""
  var authenticationState: AuthenticationState = .unauthenticated
  var isValid: Bool = false
  var errorMessage: String = ""
  var currentUserId: String = ""
  var user: NSUser? = nil
  var displayName = ""
  private var handler: AuthStateDidChangeListenerHandle?
  private var currentNonce: String?
  private var userListener: ListenerRegistration?
  
  init() {
    setupAuthStateListener()
  }
  
  deinit {
    Task { @MainActor [weak self] in
      guard let self = self else { return }
      
      if let handler = self.handler {
        Auth.auth().removeStateDidChangeListener(handler)
      }
      self.userListener?.remove()
    }
  }
  
  private func setupAuthStateListener() {
    self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.currentUserId = user?.uid ?? ""
        GlobalVariables.shared.userId = user?.uid ?? ""
        
        // Save userId to UserDefaults
        UserDefaults.standard.set(user?.uid ?? "", forKey: "userId")
        
        if !self.currentUserId.isEmpty {
          self.fetchUser()
        }
      }
    }
  }
  
  func fetchUser() {
    userListener?.remove()
    guard let userId = Auth.auth().currentUser?.uid else { return }
    let db = Firestore.firestore()
    userListener = db.collection("users").document(userId).addSnapshotListener { [weak self] documentSnapshot, error in
      guard let self = self else { return }
      if let error = error {
        print("Error fetching user: \(error.localizedDescription)")
        return
      }
      guard let data = documentSnapshot?.data() else {
        print("No user data found")
        return
      }
      let fetchedUser = NSUser(
        dateCreated: data["dateCreated"] as? String ?? "",
        email: data["email"] as? String ?? "",
        firstName: data["firstName"] as? String ?? "",
        userId: data["id"] as? String ?? ""
      )
      self.user = fetchedUser
      GlobalVariables.shared.currentUser = fetchedUser
      
      // Save current user to UserDefaults
      if let userData = try? JSONEncoder().encode(fetchedUser) {
        UserDefaults.standard.set(userData, forKey: "currentUser")
      }
    }
  }
  
  private func insertUserRecord(id: String) {
    let newUser = NSUser(dateCreated: ISO8601DateFormatter().string(from: Date()), email: email, userId: id)
    let db = Firestore.firestore()
    db.collection("users").document(id).setData(newUser.asDictionary())
  }
  
  public var isSignedIn: Bool {
    return Auth.auth().currentUser != nil
  }
}

extension Authentication {
  func signInWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do {
      let result = try await Auth.auth().signIn(withEmail: self.email, password: self.password)
      name = result.user.displayName ?? ""
      email = result.user.email ?? ""
      authenticationState = .authenticated
      return true
    } catch {
      handleAuthError(error)
      return false
    }
  }
  
  private func handleAuthError(_ error: Error) {
    print("Authentication error: \(error.localizedDescription)")
    errorMessage = error.localizedDescription
    authenticationState = .unauthenticated
  }
  
  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    guard validate() else {
      return false
    }
    do  {
      let result = try await Auth.auth().createUser(withEmail: email, password: password)
      do {
        try await result.user.sendEmailVerification()
        print("Verification email sent successfully!")
      } catch {
        print("Error sending verification email: \(error.localizedDescription)")
      }
      insertUserRecord(id: currentUserId)
      return true
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }
  
  func passwordReset(){
    Auth.auth().sendPasswordReset(withEmail: email)
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      GlobalVariables.shared.userId = ""
      GlobalVariables.shared.currentUser = nil
      UserDefaults.resetDefaults()
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }
  
  func delete() {
    Auth.auth().currentUser?.delete()
  }
  
  func validate() -> Bool {
    errorMessage = ""
    guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
          !password.trimmingCharacters(in: .whitespaces).isEmpty,
          !email.trimmingCharacters(in: .whitespaces).isEmpty else{
      return false
    }
    let emailRegex = #"^[a-zA-Z0-9._%+-]+@(gmail|yahoo|outlook|icloud)\.(com|net|org|edu)$"#
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    guard emailPredicate.evaluate(with: email) else {
      errorMessage = "Please enter a valid email address from Google, Yahoo, Outlook, or iCloud."
      return false
    }
    let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*?[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    guard passwordPredicate.evaluate(with: password) else {
      errorMessage = "Password must be at least 8 characters long and contain at least one letter and one number."
      return false
    }
    guard password == confirmPassword else{
      errorMessage = "Passwords Dont Match"
      return false
    }
    return true
  }
}

extension Authentication {
  func signInWithGoogle() async -> Bool {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
      fatalError("No client ID found in Firebase Config")
    }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootViewController = window.rootViewController else {
      print("There is no root view controller!")
      return false
    }
    do {
      let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
      let user = userAuthentication.user
      guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
      let accessToken = user.accessToken
      let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                     accessToken: accessToken.tokenString)
      let result = try await Auth.auth().signIn(with: credential)
      let firebaseUser = result.user
      name = firebaseUser.displayName ?? ""
      email = firebaseUser.email ?? ""
      insertUserRecord(id: currentUserId)
      return true
    }
    catch {
      print(error.localizedDescription)
      self.errorMessage = error.localizedDescription
      return false
    }
  }
}

extension Authentication {
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
  }
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
    if case .failure(let failure) = result {
      errorMessage = failure.localizedDescription
    }
    else if case .success(let authorization) = result {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: a login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetdch identify token.")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
          return
        }
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        Task {
          do {
            let result = try await Auth.auth().signIn(with: credential)
            await updateDisplayName(for: result.user, with: appleIDCredential)
            name = appleIDCredential.displayName()
            email = appleIDCredential.email ?? ""
            insertUserRecord(id: currentUserId)
          }
          catch {
            print("Error authenticating: \(error.localizedDescription)")
          }
        }
      }
    }
  }
  func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
    if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
    }
    else {
      let changeRequest = user.createProfileChangeRequest()
      changeRequest.displayName = appleIDCredential.displayName()
      do {
        try await changeRequest.commitChanges()
        self.displayName = Auth.auth().currentUser?.displayName ?? ""
      }
      catch {
        print("Unable to update the user's displayname: \(error.localizedDescription)")
        errorMessage = error.localizedDescription
      }
    }
  }
  
  func verifySignInWithAppleAuthenticationState() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let providerData = Auth.auth().currentUser?.providerData
    if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
      Task {
        do {
          let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
          switch credentialState {
          case .authorized:
            break
          case .revoked, .notFound:
            self.signOut()
          default:
            break
          }
        }
        catch {
        }
      }
    }
  }
}

extension ASAuthorizationAppleIDCredential {
  func displayName() -> String {
    return [self.fullName?.givenName, self.fullName?.familyName]
      .compactMap( {$0})
      .joined(separator: " ")
  }
}

private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: [Character] =
  Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length
  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }
      return random
    }
    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }
      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }
  return result
}

private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()
  return hashString
}
