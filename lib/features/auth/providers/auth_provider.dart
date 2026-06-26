import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/services/push_notification_service.dart';
import '../../../shared/models/models.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final String? phoneForOtp;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.phoneForOtp,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? phoneForOtp,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      phoneForOtp: phoneForOtp ?? this.phoneForOtp,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _apiClient;

  AuthNotifier(this._apiClient) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    final token = await _apiClient.getToken();
    if (token == null) {
      state = AuthState();
      return;
    }

    try {
      final res = await _apiClient.dio.get('/auth/me');
      if (res.data['success'] == true) {
        final user = UserModel.fromJson(res.data['data']);
        state = AuthState(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        await PushNotificationService.instance.registerToken(_apiClient);
      } else {
        await _apiClient.deleteToken();
        state = AuthState();
      }
    } catch (e) {
      await _apiClient.deleteToken();
      state = AuthState();
    }
  }

  Future<bool> requestOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _apiClient.dio.post('/auth/request-otp', data: {'phone': phone});
      state = state.copyWith(isLoading: false, phoneForOtp: phone);
      return res.data['success'] == true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal mengirim OTP. Silakan coba lagi.');
      return false;
    }
  }

  Future<bool> verifyOtp(String code) async {
    if (state.phoneForOtp == null) return false;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _apiClient.dio.post('/auth/verify-otp', data: {
        'phone': state.phoneForOtp,
        'code': code,
      });

      if (res.data['success'] == true) {
        final token = res.data['data']['token'];
        final isRegistered = res.data['data']['is_registered'] ?? false;
        await _apiClient.saveToken(token);

        if (isRegistered) {
          final user = UserModel.fromJson(res.data['data']['user']);
          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
          await PushNotificationService.instance.registerToken(_apiClient);
          return true; // go to home
        } else {
          // Token saved but profile not complete → go to biodata screen.
          // Keep isAuthenticated false so the user isn't dropped onto home yet.
          state = state.copyWith(isLoading: false);
          return false; // go to profile setup (complete biodata)
        }
      } else {
        state = state.copyWith(isLoading: false, error: 'OTP tidak valid.');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Terjadi kesalahan saat verifikasi.');
      return false;
    }
  }

  /// Completes the biodata for a freshly OTP-verified user. The token is already
  /// saved (from verifyOtp), so this hits the authenticated complete-profile
  /// endpoint instead of re-registering the phone.
  Future<bool> completeProfile({required String name, required String email}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _apiClient.dio.patch('/auth/complete-profile', data: {
        'name': name,
        'email': email,
      });

      if (res.data['success'] == true) {
        final user = UserModel.fromJson(res.data['data']['user']);
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        await PushNotificationService.instance.registerToken(_apiClient);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: res.data['message']);
        return false;
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['errors']?['email']?[0] ??
          e.response?.data?['message'] ??
          'Gagal menyimpan profil. Silakan coba lagi.';
      state = state.copyWith(isLoading: false, error: msg.toString());
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal menyimpan profil. Silakan coba lagi.');
      return false;
    }
  }

  /// Updates the signed-in user's profile (name / email).
  Future<bool> updateProfile({required String name, required String email}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _apiClient.dio.patch('/auth/profile', data: {
        'name': name,
        'email': email,
      });

      if (res.data['success'] == true) {
        final user = UserModel.fromJson(res.data['data']['user']);
        state = state.copyWith(user: user, isLoading: false);
        return true;
      }
      state = state.copyWith(isLoading: false, error: res.data['message']);
      return false;
    } on DioException catch (e) {
      final msg = e.response?.data?['errors']?['email']?[0] ??
          e.response?.data?['message'] ??
          'Gagal memperbarui profil.';
      state = state.copyWith(isLoading: false, error: msg.toString());
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memperbarui profil.');
      return false;
    }
  }

  /// Uploads a new avatar image (multipart) and refreshes the user.
  Future<bool> uploadAvatar(String filePath) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final form = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath, filename: 'avatar.jpg'),
      });
      final res = await _apiClient.dio.post('/auth/avatar', data: form);
      if (res.data['success'] == true) {
        final user = UserModel.fromJson(res.data['data']['user']);
        state = state.copyWith(user: user, isLoading: false);
        return true;
      }
      state = state.copyWith(isLoading: false, error: res.data['message']);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal mengunggah foto.');
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _apiClient.dio.post('/auth/logout');
    } catch (_) {}
    await _apiClient.deleteToken();
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthNotifier(client);
});