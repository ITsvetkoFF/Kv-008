# coding: utf-8
import datetime
import oauth2
import oauth2.store.memory

from api.utils.auth import check_password

# updated link -- using python-oauth2 with tornado
# http://python-oauth2.readthedocs.org/en/latest/tornado.html

class AuthSiteAdapter(oauth2.web.SiteAdapter):

    def user_has_denied_access(self, request):
        raise NotImplementedError

    def authenticate(self, request, environ, scopes):
        raise NotImplementedError


client_store = oauth2.store.memory.ClientStore()
token_store = oauth2.store.memory.TokenStore()

client_store.add_client(
    client_id='client_id',
    client_secret='client_secret',
    redirect_uris=['/']
)

AuthController = oauth2.Provider(
    access_token_store=token_store,
    auth_code_store=token_store,
    client_store=client_store,
    site_adapter=AuthSiteAdapter(),
    token_generator=oauth2.tokengenerator.Uuid4()
)

AuthController.add_grant(oauth2.grant.ImplicitGrant())
AuthController.add_grant(oauth2.grant.ResourceOwnerGrant())
