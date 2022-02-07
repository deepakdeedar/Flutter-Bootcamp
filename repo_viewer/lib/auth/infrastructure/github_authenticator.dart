import 'package:flutter/services.dart';
import 'package:oauth2/oauth2.dart';
import 'package:repo_viewer/auth/infrastructure/credentials_storage/credential_storage.dart';

class GithubAuthenticator {
  final CredentialsStorage _credentialsStorage;
  GithubAuthenticator(this._credentialsStorage);

  Future<Credentials?> getSignInCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();
      if (storedCredentials != null) {
        if (storedCredentials.canRefresh && storedCredentials.isExpired) {
          // TODO: refresh credentials
        }
        return storedCredentials;
      }
    } on PlatformException {
      return null;
    }
  }

  Future<bool> isSignedIn() =>
      getSignInCredentials().then((credentials) => credentials != null);
}
