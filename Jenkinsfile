pipeline {
    agent any  
    stages {
        stage('SCM'){
            steps {
                git branch: 'main', url: 'https://github.com/Hrudaya-github/megaproject.git'
            }
        }
        stage('Unit Testing'){
            steps {
                sh 'mvn test'
            }
        }
        stage('Integration Testing'){
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage('Maven Build'){
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Code Quality Analysis & Package'){
            steps {
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                    sh 'mvn clean package sonar:sonar'
                    }
                }                
            }
        }
        stage('Quality Gate Status'){
            steps {
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api'
                }
            }
        }
        stage('Upload Code in Artifact '){
            steps{
                script{
                    nexusArtifactUploader artifacts: 
                    [
                        [
                            artifactId: 'springboot', 
                            classifier: '', 
                            file: 'target/Uber.jar', 
                            type: '.jar'
                        ]
                    ], 
                        credentialsId: 'nexus-auth', 
                        groupId: 'com.example', 
                        nexusUrl: '35.153.19.242:8081', 
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        repository: 'demoapp-snapshot', 
                        version: '2.0.2-SNAPSHOT'
                }
            }
        }
    }
}
