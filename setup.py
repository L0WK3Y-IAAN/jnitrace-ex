from setuptools import setup, find_packages
from os import path

here = path.abspath(path.dirname(__file__))

with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='jnitrace-ex',
    version='3.3.1',
    description='JNITrace EX: trace JNI in Android apps (Frida 16+/17+)',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/L0WK3Y-IAAN/jnitrace-ex',
    author='chame1eon',
    maintainer='L0WK3Y-IAAN',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Debuggers',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Programming Language :: Python :: 3.12',
    ],
    keywords='frida jni sre android tracing',
    packages=find_packages(exclude=['contrib', 'docs', 'tests']),
    python_requires='>=3.7',
    install_requires=[
        'frida>=16.0.0',
        'colorama',
        'hexdump',
        'importlib_resources>=3.0.0',
        'importlib_metadata>=3.0.0; python_version < "3.8"',
    ],
    package_data={
        'jnitrace.build': ['jnitrace.js'],
    },
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'jnitrace=jnitrace.jnitrace:main',
        ],
    },
    project_urls={
        'Bug Reports': 'https://github.com/L0WK3Y-IAAN/jnitrace-ex/issues',
        'Source': 'https://github.com/L0WK3Y-IAAN/jnitrace-ex',
    },
)
