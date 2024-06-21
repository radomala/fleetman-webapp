pipeline {
   agent any

   environment {
     DOCKERHUB_CREDENTIALS = credentials('GitHub_id_pwd') // Remplacez 'dockerhub-credentials-id' par l'ID de vos identifiants Docker Hub stockés dans Jenkins
     SERVICE_NAME = "fleetman-webapp"
     REPOSITORY_TAG="${YOUR_DOCKERHUB_USERNAME}/${SERVICE_NAME}:${BUILD_ID}"
   }

   stages {
      stage('Preparation') {
         steps {
            cleanWs()
            git credentialsId: 'Identification_github', url: "https://github.com/radomala/fleetman-webapp"
         }
      }

      stage('Build') {
            steps {
                script {
                    // Builder l'application Angular
                    sh 'npm install'
                    sh 'npm run build --prod'
                }
            }
        }      
       stage('Construire image') {
         steps {
            sh "docker image build -t ${REPOSITORY_TAG} ."
          
        }
      }

       stage('Login to Docker Hub') {
         steps {
               // Se connecter à Docker Hub en utilisant les identifiants sécurisés stockés dans Jenkins
            script {
               withCredentials([string(credentialsId: 'IDENTIFICATION_HUBDOCKER', variable: 'DOCKER_HUB_PASSWORD')]) {
            
               sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
               // sh 'echo $DOCKER_HUB_PASSWORD | docker login -u  --password-stdin'
               sh "docker push radomala/fleetman-webapp:${BUILD_ID}"
               }
            }
         }
      }

      stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Déployer sur Kubernetes
                    sh 'kubectl apply -f k8s-deployment.yaml'
                    sh 'kubectl apply -f k8s-service.yaml'
                }
            }
        }
   }

 }
