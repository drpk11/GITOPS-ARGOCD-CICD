pipeline {
    agent any
   tools{
	 nodejs 'NodeJS'
	}
   environment{
		DOCKER_HUB_REPO = 'zikalina/node-argocd-image'
		DOCKER_HUB_CRED =  'gitops-dockerhub'
   }
    stages {
        stage('Checkout Github') { 
            steps {
		git branch: 'main', credentialsId: 'gitops-argo', url: 'https://github.com/drpk11/GITOPS-ARGOCD-CICD.git'
                 }
		}
        stage('Install node dependencies') { 
            steps {
                sh 'npm install'
            }
        }
        stage('Build') { 
            steps {
                script{
                    echo ' building image'
		    dockerImage = docker.build("${DOCKER_HUB_REPO}:latest")
                }
            }
        }
        stage('Trivy Scan'){
            steps {
              
              sh 'trivy image --severity HIGH,CRITICAL --skip-update --no-progress --format table -o trivy-scan-report.txt ${DOCKER_HUB_REPO}:latest'

            }
        }
        stage('Push image'){
            steps{
                script{
			echo 'push image'
			docker.withRegistry('http://registry.hub.docker.com',"${DOCKER_HUB_CRED}"){
			     dockerImage.push('latest')
                        }
		}
            }
        }
        stage('install ARGO CD CLI'){
            steps{
                sh '''
                    echo 'installing ARGO CD'
                '''
            }
        }
        stage('Applying K8s manifests file n sync with argo cd'){
            steps{
                sh '''
                    echo 'Sync with ARGO CD'
                '''
            }
        }
    }

    post{
            success {
                echo 'Build & deploy successfull'
            }
            failure {
                echo 'Build & deploy un-successfull'
            }
        }
    
}
