import os

def preBuild(path, config):
	pass

def postBuild(path, config):
	pass

def preDeploy(path, config):
	
	# Add a deploy log at /versions.txt
	
	import urllib2
	import datetime
	import platform
	import codecs
	import getpass
	
	url = config.get('aws-bucket-website')
	data = u''
	
	try:
		data = urllib2.urlopen('http://%s/versions.txt' % url).read() + u'\n'
	except:
		pass
	
	data += u'	'.join([datetime.datetime.now().isoformat(), platform.node(), getpass.getuser()])
	codecs.open(os.path.join(path, 'build', 'versions.txt'), 'w', 'utf8').write(data)

def postDeploy(path, config):
	pass
