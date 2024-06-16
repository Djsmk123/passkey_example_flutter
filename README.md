
## Registration

- **Get the required payload for `/register/start` endpoint:**
  
  ```dart
  final res = await AuthService.passKeyRegisterInit(username: username!);
  ```

- **Send the payload to Credential Manager to initiate the user approval flow for registration:**
  
  ```dart
  final credResponse = await AuthService.credentialManager.savePasskeyCredentials(request: res);
  ```

- **After user approval, send the data to `/register/complete` API for verification and user creation:**
  
  ```dart
  final user = await AuthService.passKeyRegisterFinish(
      username: username!,
      challenge: res.challenge,
      request: credResponse,
  );
  ```

## Sign-In

- **Make a GET request to `/login/start` endpoint to retrieve `challenge` and other payload:**
  
  ```dart
  final res = await AuthService.passKeyLoginInit();
  ```

- **Initiate the user approval flow for sign-in by sending the request data from `/login/start` to `CredentialManager`:**
  
  ```dart
  final credResponse = await AuthService.credentialManager.getPasswordCredentials(
      passKeyOption: CredentialLoginOptions(
          challenge: res.challenge,
          rpId: res.rpId,
          userVerification: res.userVerification,
      ),
  );
  ```

- **Verify the user by sending the data returned from `getPasswordCredentials` method to `/login/complete/` endpoint to retrieve the user object:**
  
  ```dart
  final user = await AuthService.passKeyLoginFinish(
      challenge: res.challenge,
      request: credResponse.publicKeyCredential!,
  );
  ```
