# coding: utf-8
import hashlib
import uuid


def hash_password(raw_password):
    salt = uuid.uuid4().hex
    raw_password = raw_password or salt
    password_hash = hashlib.sha512(raw_password + salt).hexdigest()
    return '$'.join([password_hash, salt])


def check_password(raw_password, hash_salt):
    splitted = hash_salt.split('$')
    assert len(splitted) == 2, 'Hash + Salt not found'
    password_hash, salt = splitted
    return password_hash == hashlib.sha512(raw_password + salt).hexdigest()
