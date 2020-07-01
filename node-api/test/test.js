let chai = require('chai');
let chaiHttp = require('chai-http');
let server = require('../app');
let should = chai.should();


chai.use(chaiHttp);

describe('/GET atm', () => {
      it('it should GET all the ATMs', (done) => {
        chai.request(server)
            .get('/api/atm-locations')
            .end((err, res) => {
				  res.should.have.status(200);
				  
				  let data = res.body["data"];
				  let rstatus = res.body["status"];
				  
                  rstatus.should.be.eql('success');
                  data.should.be.a('array');
                  data.length.should.be.eql(654);
                  done();
            });
      });
  });
  
 /*
  * Test the /POST route
  */
  describe('/POST atm', () => {
      it('it should POST an atm', (done) => {
          let atm = {
			  BankName: "TEST BANK",
			  Address: "999 Test Blvd",
			  County: "New York",
			  City: "New York",
			  State: "NY",
			  ZipCode: 999999
          }
        chai.request(server)
            .post('/api/atm-locations')
            .send(atm)
            .end((err, res) => {
                  res.should.have.status(200);
				  let rstatus = res.body["status"];
				  let rmessage = res.body["message"];
				  
				  rstatus.should.be.eql('success');
				  rmessage.should.be.eql('Inserted ONE ATM Location');
				  done();
            });
      });

  });
  
  /*
  * Test GET an atm
  */
   
  describe('/GET one atm', () => {
      it('it should GET the new added atm', (done) => {         
        chai.request(server)
            .get('/api/atm-locations/640')
            .end((err, res) => {
				  let atm = {
					  ID: 640,
					  BankName: "HSBC Bank USA, National Association",
					  Address: "45 East 89th Street",
					  County: "New York",
					  City: "New York",
					  State: "NY",
					  ZipCode: 10128
				  }
                  res.should.have.status(200);
				  let data = res.body["data"];
				  let rstatus = res.body["status"];
				  let rmessage = res.body["message"];
				  
				  data.should.be.eql(atm);
				  rstatus.should.be.eql('success');
				  rmessage.should.be.eql('Retrieved ONE ATM location');
				  done();
            });
      });

  });
  
  /*
   * Delete the new added atm
   */
  describe('/DELETE atm', () => {	   
	  it('it should DELETE the new added atm', (done) => {         
		chai.request(server)
			.delete('/api/atm-locations/655')
			.end((err, res) => {
				  res.should.have.status(200);
				  let rstatus = res.body["status"];
				  let rmessage = res.body["message"];
				  
				  rstatus.should.be.eql('success');
				  rmessage.should.be.eql('Removed ${result.rowCount} ATM Location');
				  done();
			});
	  });

  });
 