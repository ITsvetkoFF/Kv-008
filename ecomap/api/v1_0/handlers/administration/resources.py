import json

from api.v1_0.handlers.base import BaseHandler


class ResourcesHandler(BaseHandler):

    def get(self, role_id, resource_id=None, *args, **kwargs):
        if resource_id is None:
            # TODO: create query for resources which in permissions filtered by id (id taken from role_permission by role_id
            pass
        else:
            # TODO:
            pass

    def post(self, *args, **kwargs):
        pass
