pipeline{
    
     environment{
        IMAGE_NAME = "matao39/static-website"
        IMAGE_TAG = "${BUILD_TAG}"
        CONTAINER_NAME = "static-website"
        USERNAME = "matao39"
        PRODUCTION_HOST = "54.221.85.145" 

    }

    agent none

    stages{
static-website-example
        stage ('Build Image'){
            agent any
            steps{
                script{
                    sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
                }
            }
        }


        stage ('Run container based on Builded image'){
            agent any
            steps{
                script{
                    sh '''
                        docker run --name ${CONTAINER_NAME} -d -p 80:80 -e PORT=80 ${IMAGE_NAME}:${IMAGE_TAG}
                        sleep 5
                    ''' 
                }
            }
        } 

        stage ('Test Image'){
            agent any
            steps{
                script{
                    sh '''
                       curl http://172.17.0.1 | grep -q "DIMENSION"
                    '''
                }
            }
        }

        stage('Clean Container') {
            agent any
            steps {
                script {
                    sh '''
                       docker stop ${CONTAINER_NAME}
                       docker rm ${CONTAINER_NAME}
                    '''
                }
            }
        }

       stage('Push image to Dockerhub') {
            agent any
            steps {
                script {
                    sh '''
                       docker login -u ${USERNAME} -p ${PASSWORD}
                       docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        } 

}