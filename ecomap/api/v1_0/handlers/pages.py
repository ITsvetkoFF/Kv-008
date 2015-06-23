import tornado.web
import tornado.escape

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models import Page
from api.v1_0.bl.models_dict_logic import get_dict_from_orm, update_model_from_dict, get_object_from_dict


class PageHandler(BaseHandler):

    @tornado.web.authenticated
    def get(self, page_id=None, *args, **kwargs):
        if page_id:
            self.send_error(status_code=400, message='Bad Request')

    @tornado.web.authenticated
    def put(self, page_id=None, *args, **kwargs):
        model = self.sess.query(Page).filter_by(id=page_id).first()
        model = update_model_from_dict(
            model=model,
            model_dict=self.request.arguments)
        self.sess.update(model)
        self.sess.commit()

    @tornado.web.authenticated
    def post(self, page_id=None, *args, **kwargs):
        if page_id:
            self.send_error(status_code=400, message='Bad Request')

    @tornado.web.authenticated
    def delete(self, page_id, *args, **kwargs):
        self.sess.delete(self.sess.query(Page).filter_by(id=page_id).first())
        self.sess.commit()


class PagesHandler(BaseHandler):

    @tornado.web.authenticated
    def get(self, page_id=None, *args, **kwargs):
        if page_id is None:
            return self.write(tornado.escape.json_encode([get_dict_from_orm(page)
                                                          for page in self.sess.query(Page).all()]))
        else:
            return self.write(get_dict_from_orm(self.sess.query(Page).filter_by(id=page_id).first()))

    @tornado.web.authenticated
    def put(self):
            self.send_error(status_code=400, message='Bad Request')

    @tornado.web.authenticated
    def post(self, page_id=None, *args, **kwargs):
        self.sess.add(get_object_from_dict(
            model=Page,
            income_dict=self.request.arguments))
        self.sess.commit()
        return self.get(page_id=page_id, *args, **kwargs)

    @tornado.web.authenticated
    def delete(self):
        self.send_error(status_code=400, message='Bad Request')()
