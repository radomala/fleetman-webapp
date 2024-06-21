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
       stage('Construire image') {
         steps {
            sh "docker image build -t ${REPOSITORY_TAG} ."
          
        }
      }

       stage('Login to Docker Hub') {
         steps {
               // Se connecter à Docker Hub en utilisant les identifiants sécurisés stockés dans Jenkins
            script {
                  //   docker.withRegistry('https://registry.hub.docker.com', 'GitHub_id_pwd') {
                  sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                  }
                }
      }

      stage('Push  Image in hubdocker') {
            steps {
               script {
                  sh "docker push radomala/fleetman-webapp:${BUILD_ID}"
                }
            }
      }
      stage('Deploy to Cluster') {
          steps {
            sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f -'
          }
      }
   }

 }
