# coding: utf-8
import urllib
import json
from tornado.testing import AsyncHTTPTestCase
from tornado.web import Application

from api.v1_0.handlers.urls import APIUrls
from api.utils.settings import get_normalized_settings


class OAuthAPITestCase(AsyncHTTPTestCase):

    def get_app(self):
        settings = get_normalized_settings()
        application = Application(handlers=APIUrls, **settings)
        return application
