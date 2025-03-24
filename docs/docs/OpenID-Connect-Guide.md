**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract,
and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2024
The MITRE Corporation. All Rights Reserved.

# OpenID Connect Overview
Workflow Manager can use an OpenID Connect (OIDC) provider to handle authentication for users of
the web UI and clients of the REST API.


## Configuration
In order to use OIDC, Workflow Manager must first be registered with OIDC provider. The exact
process for this varies by provider.  As part of the registration process, a client ID and client
secret should be provided. Those values should be set in the `OIDC_CLIENT_ID` and
`OIDC_CLIENT_SECRET` environment variables. During the registration process the provider will
likely request a redirect URI. The redirect URI should be set to the base URI for Workflow Manager
with `/login/oauth2/code/provider` appended.

The documentation for the OIDC provider should specify the base URI a client should use to
authenticate users. The URI should be set in the `OIDC_ISSUER_URI` environment variable. To verify
the URI is correct, check that the JSON discovery document is returned when sending an HTTP GET
request to the URI with `/.well-known/openid-configuration` appended.

After a user or REST client authenticates with the OIDC provider, Workflow Manager will check for a
claim with a specific value to determine if the user is authorized to access Workflow Manager and
with what role. The `OIDC_USER_CLAIM_NAME` and `OIDC_ADMIN_CLAIM_NAME` environment variables
specify the name of the claim that must be present. The `OIDC_USER_CLAIM_VALUE` and
`OIDC_ADMIN_CLAIM_VALUE` environment variables specify the required value of the claim.


### Workflow Manager Environment Variables

- `OIDC_ISSUER_URI` (Required): URI for the OIDC provider that will be used to authenticate users
    through the web UI. If `OIDC_JWT_ISSUER_URI` is not set, `OIDC_ISSUER_URI` will also be used to
    authenticate REST clients.  The OIDC configuration endpoint must exist at the value of
    `OIDC_ISSUER_URI` with `/.well-known/openid-configuration` appended.
- `OIDC_JWT_ISSUER_URI` (Optional): Works the same way as `OIDC_ISSUER_URI`, except that the
    configuration will only be used to authenticate REST clients. When not provided,
    `OIDC_ISSUER_URI` will be used. This would be used when the authentication provider's endpoint
    for user authentication is different from the endpoint for authentication of REST clients.
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
- `OIDC_SCOPES` (Optional): A comma-separated list of the scopes to be requested from the OIDC
    provider when authenticating a user through the web UI. The OIDC specification requires one of
    the scopes to be `openid`, so if this environment variable is omitted or `openid` is not in the
    list, it will be automatically added.
- `OIDC_USER_NAME_ATTR` (Optional): The name of the claim containing the user name. Defaults to
    `sub`.
- `OIDC_REDIRECT_URI` (Optional): Specifies the URL the user's browser will be redirected to after
    logging in to the OIDC provider. If provided, the URL must end in `/login/oauth2/code/provider`.
    This would generally be used when the host name that Workflow Manager uses to connect to the
    OIDC provider is different from the OIDC provider's public host name. The value can use the
    [template variables supported by Spring.](https://docs.spring.io/spring-security/reference/servlet/oauth2/client/authorization-grants.html#oauth2Client-auth-code-redirect-uri)


## Example with Keycloak

The following example explains how to test Workflow Manager with Keycloak as the OIDC provider.
It is just an example and should not be used in production.

1\. Get the Docker gateway IP address by running the command below. It will be used in later steps.
```bash
docker network inspect --format '{{(index .IPAM.Config 0).Gateway}}' bridge
```

2\. Start Keycloak in development mode using the command below. Do not start Workflow Manager yet.
    The values for the OIDC environment variables are dependent on how you set up Keycloak in the
    following steps.
```bash
docker run -p 9090:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin \
    quay.io/keycloak/keycloak:21.1.1 start-dev
```

3\. Go to <http://localhost:9090/admin> in a browser and login with username `admin` and
    password `admin`.

4\. Create a new realm:

- Create a new realm using the drop down box in upper left that says "master".
- Use the realm name you entered and the gateway IP address from step 1 to set Workflow Manager's
    `OIDC_ISSUER_URI` environment variable to: `http://<docker-gateway-ip>:9090/realms/<realm-name>`

5\. Create the client that Workflow Manager will use to authenticate users:

- Use the "Clients" link in the left menu to create a new client.
- General Settings:
    - The "Client type" needs to be set to "OpenID Connect".
    - Enter a "Client ID".
    - Set Workflow Manager's `OIDC_CLIENT_ID` environment variable to the client ID you entered.
- Capability config:
    - "Client authentication" must be enabled.
    - "Standard flow" must be enabled.
    - "Service accounts roles" must be enabled so that Workflow Manager can include an OAuth token
        in job completion callbacks and when communicating with TiesDb.
- Login settings:
    - Set "Valid redirect URIs" to
      `http://localhost:8080/login/oauth2/code/provider`
    - Set "Valid post logout redirect URIs" to `http://localhost:8080`
- Set Workflow Manager's `OIDC_CLIENT_SECRET` environment variable to the "Client secret" in the
    "Credentials" tab.

6\. Create a Keycloak role that maps to a Workflow Manager role:

- Use the "Realm roles" link in the left menu to create a new role.
- If the Keycloak role should make the user an `ADMIN` in Workflow Manager, set Workflow
    Manager's `OIDC_ADMIN_CLAIM_VALUE` to the role name you just entered. If it should be a
    `USER`, then set the `OIDC_USER_CLAIM_VALUE` environment variable.
- Only one of `OIDC_ADMIN_CLAIM_VALUE` and `OIDC_USER_CLAIM_VALUE` need to be set. If you would
    like to set up both roles repeat this step.

7\. Include the Keycloak role(s) in the access token:

- In the "Client scopes" menu add a mapper to the "roles" scope.
- Use the "groups" predefined mapper.
- The default name "Token Claim Name" is "groups". This can be changed.
- If you created an `ADMIN` role in step 6 set `OIDC_ADMIN_CLAIM_NAME` to the value in
    "Token Claim Name". If you created a `USER` role, do the same for `OIDC_USER_CLAIM_NAME`.

8\. Optionally, set Workflow Manager's `OIDC_USER_NAME_ATTR` to `preferred_username` to display the
    user name instead of the ID.

9\. Create Users:

- After creating a user, set a password in the "Credentials" tab.
- Use the "Role mapping" tab to add the user to one of roles created in step 6.

10\. Add external REST clients:

- Use the "Clients" menu to create a new client.
- Capability config:
    - The client needs to have "Client authentication" and "Service accounts roles" enabled.
    - Use the "Service account roles" tab to add the client to one of the roles created in step 6.

11\. Start Workflow Manager. When you initially navigate to Workflow Manager, you will be
     redirected to the Keycloak log in page. You can log in using the users created in step 9.



### Test REST authentication
Using the Docker gateway IP address from step 1, the client ID and secret from step 10, and the
realm name from step 4, run the following command:
```bash
curl -d grant_type=client_credentials -u '<client-id>:<client-secret>' 'http://<docker-gateway-ip>:9090/realms/<realm-name>/protocol/openid-connect/token'
```
The response JSON will contain a token in the `"access_token"` property. That token needs to be
included as a bearer token in REST requests to Workflow Manager. For example:
```bash
curl -H "Authorization: Bearer <access-token>" http://localhost:8080/rest/actions
```


### Use OAuth when sending job complete callbacks and when posting to TiesDb.
1\. Create a client for the callback receiver or TiesDb:

- Use the "Clients" menu to create a new client.
- Capability config:
    - The client needs to have "Client authentication" and "Service accounts roles" enabled.
- Configure the callback receiver or TiesDb with the client ID and secret.

2\. Create a client role:

- Use the "Roles" tab to add a role to the client that was just created.

3\. Add the role to the Workflow Manager's client:

- Go to the client details page for the client created for Workflow Manager.
- Go to the "Service accounts roles" tab.
- Click "Assign role".
- Change "Filter by realm roles" to "Filter by clients".
- Assign the role created in step 2.

4\. Run jobs with the `CALLBACK_USE_OIDC` or `TIES_DB_USE_OIDC` job properties set to `TRUE`.


### Test callback authentication

The Python script below can be used to test callback authentication. Before running the script you
must run `pip install Flask-pyoidc==3.14.2`. To run the script, you must set the `OIDC_ISSUER_URI`,
`OIDC_CLIENT_ID`, and `OIDC_CLIENT_SECRET` environment variables. Note that the script configures
the `Flask-pyoidc` package to authenticate Web users, as required by the package, but we are only
testing the authentication of REST clients.

Once the script is running, a user can submit a job via the Workflow Manager Swagger page with the
following fields to test callbacks:
```json
{
  "callbackMethod": "POST",
  "callbackURL": "http://localhost:5000/api",
  "jobProperties": {
    "CALLBACK_USE_OIDC": "TRUE"
  }
}
```

```python
import json
import logging
import os

from flask import Flask, jsonify
from flask_pyoidc.provider_configuration import ProviderConfiguration, ClientMetadata
from flask_pyoidc import OIDCAuthentication

logging.basicConfig(level=logging.INFO)

app = Flask(__name__)
app.config.update(
    OIDC_REDIRECT_URI='http://localhost:5000/redirect_uri',
    SECRET_KEY='secret',
    DEBUG=True
)

auth = OIDCAuthentication({
    'default': ProviderConfiguration(
        os.getenv('OIDC_ISSUER_URI'),
        client_metadata=ClientMetadata(
            os.getenv('OIDC_CLIENT_ID'), os.getenv('OIDC_CLIENT_SECRET'))
    )
}, app)

@app.route('/api', methods = ('GET', 'POST'))
@auth.token_auth('default')
def api():
    print(type(auth.current_token_identity))
    print(json.dumps(auth.current_token_identity, sort_keys=True, indent=4))
    return jsonify({'message': 'test message'})

if __name__ == '__main__':
    app.run()
```
