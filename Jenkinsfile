pipeline{

    environment{
        IMAGE_NAME = "matao39/static-website"
        IMAGE_TAG = "${BUILD_TAG}"
        CONTAINER_NAME = "static-website-container"
        USERNAME = "matao39"
        PRODUCTION_HOST = "54.221.85.145"

    }

    agent none

    stages{

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
                        docker run --name ${CONTAINER_NAME} -d -p 80:5000 -e PORT=5000 ${IMAGE_NAME}:${IMAGE_TAG}
                        sleep 5
                    ''' 
                }
            }
        }

        stage ('Test Image'){
            agent any
            steps{
                 catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script{
                        sh '''
                            curl http://172.17.0.1 | grep -q "Dimension"
                        '''
                    }
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

        stage('Deploy app on EC2-cloud Production') {
            agent any
            when{
                expression{ GIT_BRANCH == 'origin/master'}
            }
            steps{
                withCredentials([sshUserPrivateKey(credentialsId: "ssh-ec2-cloud", keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        script{ 
                            sh'''
                                ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${PRODUCTION_HOST} -C \'docker rm -f static-webapp-prod\'
                                ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${PRODUCTION_HOST} -C \"docker run -d --name static-webapp-prod  -e PORT=80 -p 80:80 ${IMAGE_NAME}:${IMAGE_TAG}\"
                            '''
                        }
                    }
                }
            }
        }

    
}

}