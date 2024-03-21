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
                script{
                    sh 'mvn test'
                }
                
            }
        }
        stage('Integration Testing'){
            steps {
                script{
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        stage('Maven Build'){
            steps {
                script{
                    sh 'mvn clean install'
                }
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

                    def pom = readMavenPom file: 'pom.xml'

                    def nexusRepo = pom.version.endsWith("SNAPSHOT") ? "demoapp-snapshot" : "demoapp-release"

                    nexusArtifactUploader artifacts: 
                    [
                        [
                            artifactId: 'springboot', 
                            classifier: '', 
                            file: 'target/Uber.jar', 
                            type: 'jar'
                        ]
                    ], 
                        credentialsId: 'nexus-auth', 
                        groupId: 'com.example', 
                        nexusUrl: '35.153.19.242:8081', 
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        repository: nexusRepo, 
                        version: pom.version
                }
            }
        }
        stage('Docker Image Build'){
            steps {
                script{
                    sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID hr143heart/$JOB_NAME:v1.$BUILD_ID '
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID hr143heart/$JOB_NAME:latest '
                }
            }
        }
    }
}
