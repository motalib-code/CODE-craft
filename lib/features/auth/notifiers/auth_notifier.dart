import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../models/user_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/api_keys.dart';

// Auth state stream
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Current user data from Firestore
final userDataProvider = StateNotifierProvider<UserDataNotifier, AsyncValue<UserModel?>>((ref) {
  return UserDataNotifier(ref);
});

// Auth actions
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isNewUser;
  final bool isGuest;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isNewUser = false,
    this.isGuest = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isNewUser,
    bool? isGuest,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isNewUser: isNewUser ?? this.isNewUser,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  AuthNotifier(this._ref) : super(const AuthState());

  void setGuestMode(bool value) {
    state = state.copyWith(isGuest: value);
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: _mapError(e.code));
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> signUpWithEmail(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user?.updateDisplayName(name);

      // Create user in Firestore
      final user = UserModel(
        uid: cred.user!.uid,
        name: name,
        email: email,
        photoUrl: cred.user?.photoURL,
      );
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      await StorageService.setString(StorageService.keyUserId, user.uid);
      await StorageService.setString(StorageService.keyUserName, name);

      state = state.copyWith(isLoading: false, isNewUser: true);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Sign up failed', // ✅ Error show hoga
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId: ApiKeys.googleWebClientId,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);

      // Check if new user
      final doc = await _firestore
          .collection('users')
          .doc(userCred.user!.uid)
          .get();

      if (!doc.exists) {
        final user = UserModel(
          uid: userCred.user!.uid,
          name: userCred.user?.displayName ?? 'User',
          email: userCred.user?.email ?? '',
          photoUrl: userCred.user?.photoURL,
        );
        await _firestore.collection('users').doc(user.uid).set(user.toMap());
        state = state.copyWith(isLoading: false, isNewUser: true);
      } else {
        state = state.copyWith(isLoading: false, isNewUser: false);
      }

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

class UserDataNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref _ref;

  UserDataNotifier(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _ref.listen(authStateProvider, (_, next) {
      next.when(
        data: (user) {
          if (user != null) {
            _loadUser(user.uid);
          } else {
            state = const AsyncValue.data(null);
          }
        },
        loading: () => state = const AsyncValue.loading(),
        error: (e, s) => state = AsyncValue.error(e, s),
      );
    });
  }

  Future<void> _loadUser(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        state = AsyncValue.data(UserModel.fromMap(doc.data()!));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).update(data);
    await _loadUser(uid);
  }

  Future<void> saveOnboarding({
    required String college,
    required String year,
    required String level,
    String? githubUsername,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = {
      'college': college,
      'year': year,
      'level': level,
      'githubUsername': githubUsername,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(data);
    await StorageService.setBool(StorageService.keyOnboarded, true);
    await _loadUser(uid);
  }

  Future<void> addCoins(int amount) async {
    final current = state.value;
    if (current == null) return;
    await updateUser({'coins': current.coins + amount});
  }

  Future<void> addXp(int amount) async {
    final current = state.value;
    if (current == null) return;
    await updateUser({'xp': current.xp + amount});
  }

  Future<void> refresh() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) await _loadUser(uid);
  }
}
