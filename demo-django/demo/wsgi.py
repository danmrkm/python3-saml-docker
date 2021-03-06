"""
WSGI config for demo project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/howto/deployment/wsgi/
"""

import os
import sys

sys.path.append(os.path.dirname(os.path.abspath(__file__)) + '/..')

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "demo.settings")

from django.core.wsgi import get_wsgi_application  # noqa: E402
application = get_wsgi_application()
