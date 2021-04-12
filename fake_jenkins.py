from flask import request, Flask, jsonify
import json
import subprocess
import os

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False

service_mapping = {
	"cmp-adapter": 2108,
	"cmp-statistics": 2112,
	"cmp-gateway": 1101,
	"cmp-monitor": 2113,
	"cmp-task-orchestration": 2111,
	"cmp-physics-resource": 2110,
	"cmp-resource": 2109,
	"cmp-config": 1103,
	"cmp-registry": 1100,
	"cmp-monitor-cloud": 2114,
	"cmp-operator-log": 2115,
	"cmp-cloud-network": 2116,
	"cmp-admin-monitor": 2120,
	"cmp-mbs": 2117,
	"cmp-rds": 2118,
	"product-ecs": 9080,
	"product-order": 8080,
	"cmp-common": 2121,
	"product-ecs": 3012,
	"product-nas": 3013,
	"product-order": 3011,
	"cmp-storage": 2119
}


@app.route('/test', methods=['POST'])
def post_data():
	postData = json.loads(request.get_data())
	newVersion = postData['after'][:8]
	remoteRepo = postData['project']['git_ssh_url']
	branch = postData['ref'].split('/')[-1]
	projectName = postData['project']['name']
	projectPort = str(service_mapping[projectName])
	current_dir = os.path.abspath(os.path.dirname(__file__))
	child = subprocess.Popen('bash ' + current_dir + '/clonePackUpload.sh ' +
							 '%s %s %s %s %s ' %
							 (remoteRepo, projectName, branch, newVersion, projectPort),
							 shell=True,
							 stdout=open(current_dir + '/gunicorn-debug.log', 'a'),
							 stderr=open(current_dir + '/gunicorn-debug.log', 'a'))
	# child.wait()
	return jsonify(''), 201

@app.route('/cps', methods=['POST'])
def post_data2():
		postData = json.loads(request.get_data())
		newVersion = postData['after'][:8]
		remoteRepo = postData['project']['git_ssh_url']
		branch = postData['ref'].split('/')[-1]
		projectName = 'cloudproductservice' #postData['project']['name']
		projectPort = "3102"
		current_dir = os.path.abspath(os.path.dirname(__file__))
		child = subprocess.Popen('bash ' + current_dir + '/clonePackUpload2.sh ' +
							'%s %s %s %s %s ' %
							(remoteRepo, projectName, branch, newVersion, projectPort),
							shell=True,
							stdout=open(current_dir + '/gunicorn-debug.log', 'a'),
							stderr=open(current_dir + '/gunicorn-debug.log', 'a'))
		return jsonify(''), 201

@app.route('/fake_jenkins', methods=['POST'])
def post_data3():
                postData = json.loads(request.get_data())
                newVersion = postData['after'][:8]
                remoteRepo = postData['project']['git_ssh_url']
                branch = postData['ref'].split('/')[-1]
                projectName = postData['project']['name']
                projectPort = "123"
                current_dir = os.path.abspath(os.path.dirname(__file__))
                child = subprocess.Popen('bash ' + current_dir + '/clonePackUpload3.sh ' +
                                                        '%s %s %s %s %s ' %
                                                        (remoteRepo, projectName, branch, newVersion, projectPort),
                                                        shell=True,
                                                        stdout=open(current_dir + '/gunicorn-debug.log', 'a'),
                                                        stderr=open(current_dir + '/gunicorn-debug.log', 'a'))
                return jsonify(''), 201

if __name__ == '__main__':
	app.run(debug=False, host='0.0.0.0', port=80)
