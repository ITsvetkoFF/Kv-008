import imghdr
import random
import string
import os

from PIL import Image

import api.v1_0.bl.utils as utils
import api.v1_0.models as models

from static import STATIC_ROOT, PHOTOS_ROOT


def check_file_ext(filename):
    _, ext = os.path.splitext(filename)
    if ext in ('.jpeg', '.jpg'):
        return True

    return False


def check_file_format(file):
    # First argument of imghdr.what is ignored if second is given.
    format = imghdr.what('', file)
    if format.endswith(('jpeg', 'jpg')):
        return True

    return False


def create_new_filename():
    name = ''.join(
        random.choice(string.ascii_lowercase + string.digits)
        for x in xrange(6))

    return name + '.jpeg'


def store_photo_data_to_db(problem_id, filename, handler):
    photo = models.Photo(
        problem_id=problem_id,
        name=filename,
        datetime=utils.get_datetime(),
        user_id=handler.current_user,
        comment=handler.request.body_arguments['comments'].pop().decode(
            'utf-8')
    )
    handler.sess.add(photo)
    handler.sess.commit()


def store_file_to_hd(filename, file):
    path = os.path.join(PHOTOS_ROOT, filename)
    with open(path, 'w') as outputfile:
        outputfile.write(file)

    return path


def store_thumbnail_to_hd(path_to_file):
    _, filename = os.path.split(path_to_file)
    name, _ = os.path.splitext(filename)

    path_to_thumbnail = os.path.join(
        STATIC_ROOT, 'thumbnails', name + '.thumbnail.jpeg')

    try:
        im = Image.open(path_to_file)
        im.thumbnail((100, 100))
        im.save(path_to_thumbnail, 'JPEG')
    except IOError:
        print 'Cannot create thumbnail for', path_to_file
