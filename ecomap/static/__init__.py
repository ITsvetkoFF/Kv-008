import os


STATIC_ROOT = os.path.dirname(os.path.abspath(__file__))
PHOTOS_ROOT = os.path.join(STATIC_ROOT, 'photos')
THUMBNAILS_ROOT = os.path.join(STATIC_ROOT, 'thumbnails')
