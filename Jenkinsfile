#!/usr/bin/env groovy
@Library('sd')_
def kubeLabel = getKubeLabel()

def build_image(dirname, tags){
    deleteDir()
    unstash "source"

    dir("${dirname}"){
      sh "tags=${tags} sh build-images.sh"
      sh "tags=${tags} sh push-images.sh"
    }
}

pipeline {

  agent {
      kubernetes {
          label "${kubeLabel}"
          cloud 'Kube mwdevel'
          defaultContainer 'runner'
          inheritFrom 'ci-template'
      }
  }
  
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 3, unit: 'HOURS')
  }
  
  triggers {
    cron('@daily')
  }
  
  environment {
    DOCKER_REGISTRY_HOST = "${env.DOCKER_REGISTRY_HOST}"
  }

  stages {
    stage('prepare'){
      steps {
        checkout scm
        stash name: "source", includes: "**"
      }
    }
    
    stage('build images (1)'){
      steps {
        parallel(
          "centos6"   : { build_image('rpm', 'centos6') },
          "centos7"   : { build_image('rpm', 'centos7') },
          "centos6devtools7"  : { build_image('rpm', 'centos6devtools7') },
          "ubuntu1604": { build_image('deb', 'ubuntu1604') }
          )
      }
    }
    
    stage('result'){
      steps {
        script { currentBuild.result = 'SUCCESS' }
      }
    }
  }
  
  post {
    failure {
      slackSend color: 'danger', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Failure (<${env.BUILD_URL}|Open>)"
    }
    
    changed {
      script{
        if('SUCCESS'.equals(currentBuild.result)) {
          slackSend color: 'good', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Back to normal (<${env.BUILD_URL}|Open>)"
        }
      }
    }
  }
}
