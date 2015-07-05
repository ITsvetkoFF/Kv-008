import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import Page
from api.v1_0.bl.modeldict import (
    get_row_data,
    update_obj,
    create_obj
)
from api.v1_0.bl.decs import (
    check_permission,
    check_if_exists,
    validate_payload
)

class PageHandler(BaseHandler):
    @tornado.web.authenticated
    @check_if_exists('page')
    @check_permission('page')
    def get(self, page_id):
        self.write(get_row_data(self.sess.query(Page).get(page_id)))

    @tornado.web.authenticated
    @check_if_exists('page')
    @check_permission('page')
    def put(self, page_id):
        page = update_obj(
            self.sess.query(Page).get(page_id),
            self.request.arguments
        )
        self.sess.commit()

    @tornado.web.authenticated
    @check_if_exists('page')
    @check_permission('page')
    def delete(self, page_id):
        self.sess.delete(self.sess.query(Page).get(page_id))
        self.sess.commit()


class PagesHandler(BaseHandler):
    @tornado.web.authenticated
    @check_permission('all_pages')
    def get(self):
        self.write(tornado.escape.json_encode(
            [get_row_data(page) for page in self.sess.query(Page)]))

    @tornado.web.authenticated
    @check_permission('page')
    def post(self, page_id):
        self.sess.add(create_obj(Page, self.request.arguments))
        self.sess.commit()
