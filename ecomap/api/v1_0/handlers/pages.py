from sqlalchemy.exc import IntegrityError
import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.bl.decs import check_permission, check_if_exists
from api.v1_0.models import Page
from api.v1_0.bl.modeldict import get_row_data, update_row_data
from api.v1_0.bl.decs import validation
from api.v1_0.forms.page import PageForm, PutPageFrom


class PageHandler(BaseHandler):
    @tornado.web.authenticated
    @check_if_exists(Page)
    def get(self, page_id):
        self.write(get_row_data(self.sess.query(Page).get(page_id)))

    @tornado.web.authenticated
    @check_if_exists(Page)
    @check_permission
    @validation(PutPageFrom)
    def put(self, page_id):
        try:
            self.sess.query(Page).filter_by(id=int(page_id)). \
                update(self.request.arguments)
            self.sess.commit()
        except IntegrityError:
            self.write_error(400, message='Alias already exists.')




    @tornado.web.authenticated
    @check_if_exists(Page)
    @check_permission
    def delete(self, page_id):
        self.sess.delete(self.sess.query(Page).get(page_id))
        self.sess.commit()


class PagesHandler(BaseHandler):
    def get(self):
        self.write(tornado.escape.json_encode(
            [{
             'alias':p.alias,
             'title':p.title,
             'id':p.id,
             'is_resource':p.is_resource
             } for p in self.sess.query(Page)]))

    @tornado.web.authenticated
    @validation(PageForm)
    @check_permission
    def post(self):
        """{
        "title": "t_1",
        "content": "page_test",
        "alias": "alias_1",
        "is_resource": "False"
        }"""
        self.sess.add(Page(**self.request.arguments))
        self.sess.commit()
