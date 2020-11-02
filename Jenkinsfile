// Para consigna 9

pipeline {
    agent { label 'docker'}

    environment {
        dockerImage = ''
        credentials = 'docker-hub'
        kubernetesToken = credentials('kubernetes-token')
    }

    stages {
        stage('Build') {
            steps {
                container('docker') {
                    script {
                        if (env.BRANCH_NAME == 'develop') {
                            dockerImage = docker.build "limapaulabelen/webgo:${BUILD_NUMBER}"
                        } else {
                            echo 'In master branch. Skipping this step' //Esto no es necesario, pero está acá para depuración
                        }
                    }
                }
            }
        }
        stage('Publish') {
            steps {
                container('docker') {
                    script {
                        if (env.BRANCH_NAME == 'develop') {
                            docker.withRegistry('', credentials) {
                                dockerImage.push()
                                dockerImage.push('latest')
                            }
                        } else {
                            echo 'In master branch. Skipping this step' //Esto no es necesario, pero está acá para depuración
                        }  
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                container('kubedocker') {
                    script {
                        if (env.BRANCH_NAME == 'master') {
                            sh 'kubectl --server https://10.0.2.10:6443 --token=${kubernetesToken} --insecure-skip-tls-verify apply -f webgo.prod.yaml' 

                        } else {
                            sh 'kubectl --server https://10.0.2.10:6443 --token=${kubernetesToken} --insecure-skip-tls-verify apply -f webgo.yaml'
                        }
                    }
                }
            }
        }
    }
}