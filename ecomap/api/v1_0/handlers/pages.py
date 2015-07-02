import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import Page
from api.v1_0.bl.modeldict import (
    loaded_obj_data_to_dict,
    update_loaded_obj_with_data,
    create_obj_with_data
)


class PageHandler(BaseHandler):
    def get(self, page_id):
        self.write(loaded_obj_data_to_dict(self.sess.query(Page).get(page_id)))

    def put(self, page_id):
        page = update_loaded_obj_with_data(
            self.sess.query(Page).get(page_id),
            self.request.arguments
        )
        self.sess.commit()

    def delete(self, page_id):
        self.sess.delete(self.sess.query(Page).get(page_id))
        self.sess.commit()


class PagesHandler(BaseHandler):
    def get(self):
        self.write(tornado.escape.json_encode(
            [loaded_obj_data_to_dict(page) for page in self.sess.query(Page)]))

    def post(self, page_id):
        self.sess.add(create_obj_with_data(Page, self.request.arguments))
        self.sess.commit()
