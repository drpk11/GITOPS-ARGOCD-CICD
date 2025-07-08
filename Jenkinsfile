pipeline {
    agent any
   tools{
	 nodejs 'NodeJS'
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
                    echo 'build docker image'
                }
            }
        }
        stage('Trivy Scan'){
            steps {
                sh '''
                    echo 'scanning the image'
                '''
            }
        }
        stage('Push image'){
            steps{
                sh '''
                    echo 'push the image to docker hub'
                '''
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
