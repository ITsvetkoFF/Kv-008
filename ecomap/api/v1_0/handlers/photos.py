import os

from api.v1_0.bl.decs import check_if_exists
from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models.photo import Photo
from static import STATIC_ROOT

PHOTOS_ROOT = os.path.join(STATIC_ROOT, 'photos')


class PhotoHandler(BaseHandler):
    @check_if_exists(Photo)
    def get(self, photo_id):
        """Returns data for the specified photo."""
        photo = self.sess.query(Photo).get(photo_id)
        self.write(dict(
            problem_id=photo.problem_id,
            name=photo.name,
            comment=photo.comment,
            datetime=photo.datetime,
            user_id=photo.user_id
        ))

    @check_if_exists(Photo)
    def put(self, photo_id):
        """Updates data for the specified photo.

        At the moment you can update only the photo's comment."""
        photo = self.sess.query(Photo).get(photo_id)
        photo.comment = self.request.arguments.get('comment')

        self.sess.commit()

    @check_if_exists(Photo)
    def delete(self, photo_id):
        """Deletes the specified photo.

        Photo is deleted from the database and removed from the hard drive
        as well."""
        photo = self.sess.query(Photo).get(photo_id)
        os.remove(os.path.join(PHOTOS_ROOT, photo.name))

        self.sess.delete(photo)
        self.sess.commit()
