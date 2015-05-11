# coding: utf-8
from tornado.testing import AsyncHTTPTestCase
from tornado.web import Application

from ecomap.urls import UrlsTable
from api.utils.settings import get_normalized_settings


class OAuthAPITestCase(AsyncHTTPTestCase):

    def get_app(self):
        settings = get_normalized_settings()
        application = Application(handlers=UrlsTable, **settings)
        return application
