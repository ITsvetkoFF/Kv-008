# coding: utf-8
import hashlib
import hmac

from api import settings

# hash which used sha1 + hex, where k - key(salt) and p - password.
hash_password = lambda p: hmac.new(digestmod=hashlib.sha1, key=str(settings['salt']), msg=str(p.strip())).hexdigest()