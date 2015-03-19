DATADIR = data
RECORD = slp01a

mat:
	cd $(DATADIR)/$(RECORD) ;\
	wfdb2mat -r $(RECORD)

edf:
	cd $(DATADIR)/$(RECORD) ;\
	mit2edf -r $(RECORD)

clean:
	rm -f $(DATADIR)/$(RECORD)/$(RECORD).edf
	rm -f $(DATADIR)/$(RECORD)/$(RECORD)m.{mat,hea}
