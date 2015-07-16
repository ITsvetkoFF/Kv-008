# coding: utf-8
import hashlib
import hmac

# hash which used sha1 + hex, where k - key(salt) and p - password.
hash_password = lambda k, p: hmac.new(digestmod=hashlib.sha1, key=k, msg=p).hexdigest().strip()
