import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.bl.decs import check_permission, check_if_exists
from api.v1_0.models import Page
from api.v1_0.bl.modeldict import get_row_data, update_row_data


class PageHandler(BaseHandler):
    @tornado.web.authenticated
    @check_if_exists(Page)
    def get(self, page_id):
        self.write(get_row_data(self.sess.query(Page).get(page_id)))

    @tornado.web.authenticated
    @check_if_exists(Page)
    @check_permission
    def put(self, page_id):
        page = update_row_data(
            self.sess.query(Page).get(page_id),
            self.request.arguments
        )
        self.sess.commit()

    @tornado.web.authenticated
    @check_if_exists(Page)
    @check_permission
    def delete(self, page_id):
        self.sess.delete(self.sess.query(Page).get(page_id))
        self.sess.commit()


class PagesHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self):
        self.write(tornado.escape.json_encode(
            [get_row_data(page) for page in self.sess.query(Page)]))

    @tornado.web.authenticated
    @check_permission
    def post(self):
        self.sess.add(Page(self.request.arguments))
        self.sess.commit()
