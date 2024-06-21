pipeline {
   agent any

   environment {
     // You must set the following environment variables
     // ORGANIZATION_NAME
     // YOUR_DOCKERHUB_USERNAME (it doesn't matter if you don't have one)
     
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
      stage('Build and Push Image') {
         steps {
           sh 'docker image build -t ${REPOSITORY_TAG} .'
         }
      }

      stage('Deploy to Cluster') {
          steps {
            sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f -'
          }
      }
   }
}
