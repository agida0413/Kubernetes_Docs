pipeline {
    agent any

    parameters {
        // GitHub  사용자명 입력
        string(name: 'GITHUB_USERNAME',  defaultValue: '', description: 'GitHub  사용자명을 입력하세요.')
    }

    environment {
        // 전역값을 넣어 두시면 위 parameters 입력이 필요 없어요. (전체 Jenkinfile에서 해당 내용을 모두 수정해 놓으면 좋습니다.)
        // GITHUB_USERNAME = ""

        // 아래 부분 수정(x)
        GITHUB_URL = "https://github.com/${GITHUB_USERNAME}/kubernetes-anotherclass-sprint2.git"
        CLASS_NUM = '2213'
    }

    stages {

        stage('Username 확인') {
            steps {
                script {
                    if (!env.GITHUB_USERNAME?.trim()) {
                        error "[파라미터와 함께 빌드]에 GITHUB_USERNAME를 본인의 username으로 입력해 주세요! 매번 입력이 번거롭다면 Jenkinsfile에서 parameters에 입력 항목을 삭제 하시고 environment에 전역값을 넣은 후 해당 조건문은 삭제해 주세요. "
                    }
                }
            }
        }

        stage('릴리즈파일 체크아웃') {
            steps {
                checkout scmGit(branches: [[name: '*/main']],
                        extensions: [[$class: 'SparseCheckoutPaths',
                                      sparseCheckoutPaths: [[path: "/${CLASS_NUM}"]]]],
                        userRemoteConfigs: [[url: "${GITHUB_URL}"]])
            }
        }

        stage('쿠버네티스 Blue배포') {
            steps {
                sh "kubectl apply -f ./${CLASS_NUM}/deploy/k8s/blue/namespace.yaml"
                sh "kubectl apply -f ./${CLASS_NUM}/deploy/k8s/blue/configmap.yaml"
                sh "kubectl apply -f ./${CLASS_NUM}/deploy/k8s/blue/secret.yaml"
                sh "kubectl apply -f ./${CLASS_NUM}/deploy/k8s/blue/service.yaml"
                sh "kubectl apply -f ./${CLASS_NUM}/deploy/k8s/blue/deployment.yaml"
            }
        }

        stage('배포 시작') {
            steps {
                input message: '수동배포 시작', ok: "Yes"
            }
        }

        stage('쿠버네티스 Green배포') {
            steps {
	        	sh "kubectl apply -f ./${CLASS_NUM}/deploy/k8s/green/deployment.yaml"
                sh "kubectl apply -f ./${CLASS_NUM}/deploy/k8s/green/service.yaml"
            }
        }

        stage('전환여부 확인') {
            steps {
                script {
                    returnValue = input message: 'Green 전환?', ok: "Yes", parameters: [booleanParam(defaultValue: true, name: 'IS_SWITCHED')]
                    if (returnValue) {
                        sh "kubectl patch -n anotherclass-221 svc api-tester -p '{\"spec\": {\"selector\": {\"blue-green-no\": \"2\"}}}'"
                    }
                }
            }
        }

        stage('롤백 확인') {
            steps {
                script {
                    returnValue = input message: 'Blue 롤백?', parameters: [choice(choices: ['done', 'rollback'], name: 'IS_ROLLBACk')]
                    if (returnValue == "done") {
                        sh "kubectl delete -f ./${CLASS_NUM}/deploy/k8s/blue/deployment.yaml"
                        sh "kubectl delete -f ./${CLASS_NUM}/deploy/k8s/green/service.yaml"
                        sh "kubectl patch -n anotherclass-221 svc api-tester -p '{\"metadata\": {\"labels\": {\"version\": \"2.0.0\"}}}'"
                        sh "kubectl patch -n anotherclass-221 cm api-tester-properties -p '{\"metadata\": {\"labels\": {\"version\": \"2.0.0\"}}}'"
                        sh "kubectl patch -n anotherclass-221 secret api-tester-postgresql -p '{\"metadata\": {\"labels\": {\"version\": \"2.0.0\"}}}'"
                    }
                    if (returnValue == "rollback") {
                        sh "kubectl patch -n anotherclass-221 svc api-tester -p '{\"spec\": {\"selector\": {\"blue-green-no\": \"1\"}}}'"
                    }
                }
            }
        }
    }

}