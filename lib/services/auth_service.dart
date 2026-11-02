import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  //firebase instance creation
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //current login user
  User? get currentUser => firebaseAuth.currentUser;
  //auth state stream
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> createAccountWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword({required String  email}) async
  {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserName({required String userName}) async
  {
    await currentUser!.updateDisplayName(userName);
  }


  Future<void> signOut()
  async{
    await firebaseAuth.signOut();
  }

}
