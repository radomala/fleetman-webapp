pipeline {
   agent any

   environment {
     // You must set the following environment variables
     // ORGANIZATION_NAME
     // YOUR_DOCKERHUB_USERNAME (it doesn't matter if you don't have one)
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
      //stage('Install Dependencies') {
      //   steps {
                // Install npm dependencies
      //          sh 'npm install'
      //      }
      //  }
      //  stage('Build') {
      //      steps {
                // Build the Angular project  for production
      //          sh 'ng build --prod'
      //      }
     // }
       stage('Push Image') {
         steps {
            script { 
              sh 'docker image build -t ${REPOSITORY_TAG} .'
            }
        }
      }
      
       stage('Login to Docker Hub') {
         steps {
            // Se connecter à Docker Hub
            sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push Docker Image') {
            steps {
                // Pousser l'image Docker vers Docker Hub
                sh 'docker push $REPOSITORY_TAG'
            }
        }
      stage('Deploy to Cluster') {
          steps {
            sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f -'
          }
      }
   }
}
