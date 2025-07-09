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
                script{
			sh '''
echo "Installing kubectl and Argo CD CLI (without sudo)..."

# Create a bin folder in the workspace
mkdir -p $HOME/bin
export PATH=$HOME/bin:$PATH

# Download kubectl
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl $HOME/bin/kubectl

# Download Argo CD CLI
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd
mv argocd $HOME/bin/argocd

# Add to PATH for the current shell session
export PATH=$HOME/bin:$PATH

# Verify tools
$HOME/bin/kubectl version --client
$HOME/bin/argocd version
'''

		}
            }
        }
        stage('Applying K8s manifests file n sync with argo cd'){
            steps{
                script{
			kubeconfig(credentialsId: 'kubeconfig', serverUrl: 'https://127.0.0.1:64118') {
    				sh '''
		 ARGOCD_PASSWORD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

                # Login to Argo CD CLI
                argocd login 127.0.0.1:56137 --username admin --password $ARGOCD_PASSWORD --insecure

                 '''

			}
		}
		    
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
