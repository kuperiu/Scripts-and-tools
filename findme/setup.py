try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

config = {
    'description': 'Find Me',
    'author': 'Lior Kuperiu',
    'author_email': 'kuperiu@gmail.com',
    'version': '0.1',
    'install_requires': ['awscli','boto3','lpthw.web'],
    'name': 'FindMe'
}

setup(**config)
