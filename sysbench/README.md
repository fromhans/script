특정 CSP사에서는 Postgresql의 public schema에 DB, Table 생성 권한을 막아놨다.

sysbench는 초기 데이터 삽입을 위한 prepare 단계에서 public schema를 사용한다.

그에 따라, lua 스크립트를 수정해서 sbtest라는 스키마에 초기데이터를 삽입하도록 변경되었다.

### 테스트 대상 Postgresql DB에 스키마 사전 생성 필요
테스트 대상 postgresql db에 sysbench prepare를 수행하기 전에, sbtest라는 스키마를 새로 생성하도록 한다.
 (db는 sysbench 명령어 수행시 --pgsql-db 아규먼트를 통해 명시된다.)
