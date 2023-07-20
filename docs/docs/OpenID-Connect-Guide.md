**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2023
The MITRE Corporation. All Rights Reserved.

# OpenID Connect Overview
Workflow Manager can use an OpenID Connect (OIDC) provider to handle authentication for users of
the web UI and clients of the REST API.


## Configuration
In order to use OIDC, Workflow Manager must first be registered with OIDC provider. The exact
process for this varies by provider.  As part of the registration process, a client ID and client
secret should be provided. Those values should be set in the `OIDC_CLIENT_ID` and
`OIDC_CLIENT_SECRET` environment variables. During the registration process the provider will
likely request a redirect URI. The redirect URI should be set to the base URI for Workflow Manger
with `/login/oauth2/code/provider` appended.

The documentation for the OIDC provider should specify the base URI a client should use to
authenticate users. The URI should be set in the `OIDC_ISSUER_URI` environment variable. To verify
the URI is correct, check that the JSON discovery document is returned when sending an HTTP GET
request to the URI with `/.well-known/openid-configuration` appended.

After a user or REST client authenticates with the OIDC provider, Workflow Manager will check for a
claim with a specific value to determine if the user is authorized to access Workflow Manager and
with what role. The `OIDC_USER_CLAIM_NAME` and `OIDC_ADMIN_CLAIM_NAME` environment variables
specify the name of claim that must be present. The `OIDC_USER_CLAIM_VALUE` and
`OIDC_ADMIN_CLAIM_VALUE` environment variables specify the required value of the claim.



### Environment Variables

- `OIDC_ISSUER_URI` (Required): URI for the OIDC provider that will be used to authenticate users
    through the web UI. If `OIDC_JWT_ISSUER_URI` is not set, `OIDC_ISSUER_URI` will also be used to
    authenticate REST clients.  The OIDC configuration endpoint must exist at the value of
    `OIDC_ISSUER_URI` with `/.well-known/openid-configuration` appended.
- `OIDC_JWT_ISSUER_URI` (Optional): Works the same way as `OIDC_ISSUER_URI`, except that the
    configuration will only be used to authenticate REST clients. When not provided,
    `OIDC_ISSUER_URI` will be used.
- `OIDC_CLIENT_ID` (Required): The client ID that Workflow Manager will use to authenticate with
    the OIDC provider.
- `OIDC_CLIENT_SECRET` (Required): The client secret Workflow Manager will use to authenticate
    with the OIDC provider.
- `OIDC_USER_CLAIM_NAME` (Optional): Specifies the name of the claim from the authentication token
    that is required for a user or REST client to be granted access to Workflow Manager with the
    `USER` role.
- `OIDC_USER_CLAIM_VALUE` (Optional): Specifies the required value of the claim specified in
    `OIDC_USER_CLAIM_NAME`. If the claim is a list, only one of the values in the list must match.
- `OIDC_ADMIN_CLAIM_NAME` (Optional): Specifies the name of the claim from the authentication token
    that is required for a user or REST client to be granted access to Workflow Manager with the
    `ADMIN` role.
- `OIDC_ADMIN_CLAIM_VALUE` (Optional): Specifies the required value of the claim specified in
    `OIDC_ADMIN_CLAIM_NAME`. If the claim is a list, only one of the values in the list must match.
- `OIDC_SCOPES` (Optional): A comma-separated list the scopes to be requested from the OIDC
    provider when authenticating a user through the web UI. The OIDC specification requires one of
    the scopes to be `openid`, so if this environment variable is omitted or `openid` is not in the
    list, it will be automatically added.
- `OIDC_USER_NAME_ATTR` (Optional): The name of the claim containing the user name. Defaults to
    `sub`.



## Example with Keycloak

The following example explains how to test Workflow Manager with Keycloak as the OIDC provider.
It is just an example and should not be used in production.

1\. Start Keycloak in development mode:
```bash
docker run -p 9090:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin \
    quay.io/keycloak/keycloak:21.1.1 start-dev
```

2\. Go to <http://localhost:9090/admin> in a browser and login with username `admin` and
    password `admin`.

3\. Create a new realm:

- Click the dropdown box in the upper left that says "master".
- Click "Create Realm".
- Enter a realm name.
- Click "Create".
- Use the realm name you entered to set Workflow Manager's `OIDC_ISSUER_URI` environment
    variable to: `http://localhost:9090/realms/<realm-name>`


4\. Create the client Workflow Manager will use to authenticate users:

- Click "Clients" in the left menu.
- Click "Create client".
- Make sure "Client type" is "OpenID Connect".
- Enter a client ID.
- Click "Next".
- Enable "Client authentication".
- Make sure "Standard flow" is checked.
- Click "Next"
- In "Valid redirect URIs" enter the base URL for Workflow Manager with
    `/login/oauth2/code/provider` appended.
- In "Valid post logout redirect URIs" enter the base URL for Workflow Manager.
- Click "Save"
- Set Workflow Manager's `OIDC_CLIENT_ID` environment variable to the client ID you entered.
- On the "Client details" page for the new client go to the "Credentials" tab.
- Click the eye icon next to "Client secret".
- Set Workflow Manager's `OIDC_CLIENT_SECRET` environment variable to the value displayed in
    "Client secret".

5\. Create a Keycloak role that maps to a Workflow Manager role:

- Click "Realm roles" in the left menu.
- Click "Create role".
- Enter a "Role name".
- Click "Save".
- If the Keycloak role should make the user an `ADMIN` in Workflow Manager, set Workflow
    Manager's `OIDC_ADMIN_CLAIM_VALUE` to the role name you just entered. If it should be a
    `USER`, then set the `OIDC_USER_CLAIM_VALUE` environment variable.
- Only one of `OIDC_ADMIN_CLAIM_VALUE` and `OIDC_USER_CLAIM_VALUE` need to be set. If you would
    like to set up both roles repeat this step.

6\. Include the Keycloak role(s) in the access token:

- Click "Client scopes" in the left menu.
- Click "roles".
- Click the "Mappers" tab.
- Click "Add mapper"
- Click "From predefined mappers".
- Check "groups".
- Click "Add".
- The default name "Token Claim Name" is "groups". This can be changed.
- If you created an `ADMIN` role in step 5 set `OIDC_ADMIN_CLAIM_NAME` to the value in
    "Token Claim Name". If you created a `USER` role, do the same for `OIDC_USER_CLAIM_NAME`.

7\. Optionally, configure Workflow Manager to display the user name instead of the ID.

- Set Workflow Manager's `OIDC_USER_NAME_ATTR` environment variable to `preferred_username`.

8\. Create users:

- Click "Users" in the left menu.
- Click "Create new user".
- Enter a "Username".
- Click "Create".
- Click the "Credentials" tab.
- Click "Set password".
- Set a password.
- Uncheck "Temporary".
- Click "Save".
- Click the "Role mapping" tab.
- Click "Assign role".
- Check one of the roles create in step 5.
- Click "Assign".

9\. You should now be able to start Workflow Manager. When you initially navigate to Workflow
   Manager, you will be redirected to the Keycloak log in page. You can log in using the
   users created in step 8.

10\. Add REST clients:

- Click "Clients" in the left menu.
- Click "Create client".
- Set a "Client ID".
- Click "Next".
- Enable "Client authentication".
- Enable "Service accounts roles".
- Click "Next".
- Click "Save".
- Click the "Service account roles" tab.
- Click "Assign role".
- Check a role created in step 5.
- Click "Assign".


### Test REST authentication
Using the client id/secret from step 10 and the realm name from step 3, run the following command:
```bash
curl -d grant_type=client_credentials -u '<client-id>:<client-secret>' 'http://localhost:9090/realms/<realm-name>/protocol/openid-connect/token'
```
The response JSON will contain a token in the `"access_token"` property. That token need to
included as a bearer token in REST requests to Workflow Manager. For example:
```bash
curl -H "Authorization: Bearer <access-token>" http://localhost:8080/workflow-manager/rest/jobs/1
```
