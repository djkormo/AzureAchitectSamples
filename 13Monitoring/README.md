Opis sytuacji:
Czeœæ Drogi Architekcie! 
W tym tygodniu niczego nie migrujemy :) Migracja prawie skoñczona, ciê¿ko na ni¹ pracowa³eœ przez ca³y kurs. Teraz jest trudniej – wszystko „zmigrowane” wiêc trzeba rozwi¹zanie utrzymaæ. I na pewno nie powinniœmy tutaj u¿ywaæ tradycyjnych metod – w chmurze musimy ca³y myœleæ o automatyzacji, bazowaniu na agregatach danych oraz wykonywaniu dzia³añ naprawczych zamiast wysy³ania kolejnych powiadomieñ.

Co wiêcej, Twój sklep e-commerce, który stworzy³eœ te¿ ju¿ jest uruchomiony w chmurze, dzia³a, ma siê dobrze ale ci¹gle wymaga czasami okresowego i o¿ywczego restartu innych. 

Teraz przed Tob¹ 3 du¿e zadania – musimy wypracowaæ strategiê monitorowania i utrzymania œrodowiska, ale z drugiej strony dobrze to zaplanowaæ bo rozwi¹zania omawiane s¹ du¿e, szybko siê skaluj¹ i s¹ nie tylko w chmurze. 

Zadanie
 
13.1 Wybierz wszystkie rozwi¹zania, których mo¿esz u¿yæ do monitorowania Twojej zmigrowanej do chmury aplikacji.

Ale nie tak szybko… masz przemyœleæ swoje wybory. U¿yj rozwi¹zania zarówno do natychmiastowego rejestrowania metryk jak i takiego, gdzie logi od³o¿¹ siê na 90 dni. SprawdŸ, jak zastosujesz w tej konstrukcji Application Insight. Czy w œrodowisku samych maszyn to rozwi¹zanie ma nadal sens?
Jak podejdziesz do monitorowania aspektów bezpieczeñstwa? Których rozwi¹zañ u¿yjesz i dlaczego? Czy finansowo ma sens duplikowaæ role w ró¿nych rozwi¹zaniach w Azure?
 
13.2 Azure Backup oraz Azure Site Recovery
Twoje rozwi¹zanie ju¿ poprawnie pracuje w chmurze, ale wypada³oby rozwa¿yæ strategiê kopii zapasowych oraz ew. replikacji do drugiego regionu.
Za³ó¿my, ¿e Twoja aplikacja to rozwi¹zanie oparte o Apache oraz MySQL, wszystko pracuje sobie na maszynach wirtualnych w Canada Central i wykorzystuje Availability Set’s.
Opisz, co trzeba by zrobiæ, by za pomoc¹ Azure Backup wykonywaæ spójny aplikacyjnie backup oraz replikê œrodowiska do drugiego regionu z RPO nie wiêkszym ni¿ 1 godzina. 
  
13.3 Automation 
Azure Automation z DSC to naprawdê bogate rozwi¹zanie. Daje spore mo¿liwoœci i pozwala na co najmniej kilka ciekawych scenariuszy. Spróbuj zbudowaæ dwa:
1)	Spraw by twoja maszyna po utworzeniu mia³a zainstalowanego IIS z uruchomion¹ bazow¹ stron¹ HTML, która zostanie pobrana z dowolnego miejsca z publicznym endpointem
2)	Spróbuj za pomoc¹ Azure Automation napisaæ skrypt, który przechodzi po wszystkich maszynach w ramach Azure i w ka¿dej z nich restartuje serwer IIS wewn¹trz maszyny.
