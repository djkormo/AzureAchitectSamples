Opis sytuacji:
Cze�� Drogi Architekcie! 
W tym tygodniu niczego nie migrujemy :) Migracja prawie sko�czona, ci�ko na ni� pracowa�e� przez ca�y kurs. Teraz jest trudniej � wszystko �zmigrowane� wi�c trzeba rozwi�zanie utrzyma�. I na pewno nie powinni�my tutaj u�ywa� tradycyjnych metod � w chmurze musimy ca�y my�le� o automatyzacji, bazowaniu na agregatach danych oraz wykonywaniu dzia�a� naprawczych zamiast wysy�ania kolejnych powiadomie�.

Co wi�cej, Tw�j sklep e-commerce, kt�ry stworzy�e� te� ju� jest uruchomiony w chmurze, dzia�a, ma si� dobrze ale ci�gle wymaga czasami okresowego i o�ywczego restartu innych. 

Teraz przed Tob� 3 du�e zadania � musimy wypracowa� strategi� monitorowania i utrzymania �rodowiska, ale z drugiej strony dobrze to zaplanowa� bo rozwi�zania omawiane s� du�e, szybko si� skaluj� i s� nie tylko w chmurze. 

Zadanie
 
13.1 Wybierz wszystkie rozwi�zania, kt�rych mo�esz u�y� do monitorowania Twojej zmigrowanej do chmury aplikacji.

Ale nie tak szybko� masz przemy�le� swoje wybory. U�yj rozwi�zania zar�wno do natychmiastowego rejestrowania metryk jak i takiego, gdzie logi od�o�� si� na 90 dni. Sprawd�, jak zastosujesz w tej konstrukcji Application Insight. Czy w �rodowisku samych maszyn to rozwi�zanie ma nadal sens?
Jak podejdziesz do monitorowania aspekt�w bezpiecze�stwa? Kt�rych rozwi�za� u�yjesz i dlaczego? Czy finansowo ma sens duplikowa� role w r�nych rozwi�zaniach w Azure?
 
13.2 Azure Backup oraz Azure Site Recovery
Twoje rozwi�zanie ju� poprawnie pracuje w chmurze, ale wypada�oby rozwa�y� strategi� kopii zapasowych oraz ew. replikacji do drugiego regionu.
Za��my, �e Twoja aplikacja to rozwi�zanie oparte o Apache oraz MySQL, wszystko pracuje sobie na maszynach wirtualnych w Canada Central i wykorzystuje Availability Set�s.
Opisz, co trzeba by zrobi�, by za pomoc� Azure Backup wykonywa� sp�jny aplikacyjnie backup oraz replik� �rodowiska do drugiego regionu z RPO nie wi�kszym ni� 1 godzina. 
  
13.3 Automation 
Azure Automation z DSC to naprawd� bogate rozwi�zanie. Daje spore mo�liwo�ci i pozwala na co najmniej kilka ciekawych scenariuszy. Spr�buj zbudowa� dwa:
1)	Spraw by twoja maszyna po utworzeniu mia�a zainstalowanego IIS z uruchomion� bazow� stron� HTML, kt�ra zostanie pobrana z dowolnego miejsca z publicznym endpointem
2)	Spr�buj za pomoc� Azure Automation napisa� skrypt, kt�ry przechodzi po wszystkich maszynach w ramach Azure i w ka�dej z nich restartuje serwer IIS wewn�trz maszyny.
