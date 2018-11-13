Opis sytuacji:
Czeœæ Drogi Architekcie! 
Pewnie doskonale pamiêtasz o produkcie czyli Twoim e-commerce’owym rozwi¹zaniu.
Ju¿ mia³eœ okazjê projektowaæ architektury z nim zwi¹zane, czas by pójœæ o krok dalej i rozwa¿yæ jak wykorzystaæ t¹ ca³¹ wiedzê o danych, by dobrze zaprojektowaæ model ich sk³adowania.

Przypomnê Ci o Twojej roli i firmie. 
Jesteœ architektem w firmie, która tworzy systemy w bran¿y e-commerce dla innych firm, które sprzedaj¹ w modelu business-to-consumer w ca³ej Europie. Systemy budujesz w oparciu o Microsoft Azure i strategia budowania systemów Cloud Native zosta³a przyjêta i jest w pe³ni akceptowana przez Twoich klientów
Jako architekt mo¿esz zdecydowaæ zarówno o architekturze systemu jak i wzorcach, które wykorzystasz. Klienci oczekuj¹ dobrze zaprojektowanego systemu, nie wnikaj¹ w Twoje decyzje.  
System, który projektujesz, bêdzie odwiedzany przez klientów koñcowych, a wiêc mo¿esz siê spodziewaæ, ¿e:
1)	W wybranych godzinach bêdzie zarówno du¿o odwiedzin strony jak i du¿o zamówieñ
2)	System bêdzie mia³ bardzo nieprzewidywaln¹ liczbê zamówieñ – zdarz¹ siê okresy, ¿e z systemu nikt nie bêdzie korzysta³, ale te¿ zdarzy siê promocja typu „Black Friday”
3)	Do systemu importuj¹ swoje towary równie¿ partnerzy firmy, którzy w ró¿nych okresach roku promuj¹ wybrane produkty
4)	System musi byæ jak najbardziej odporny na sytuacje awaryjne – jego podstawowa funkcjonalnoœæ, czyli sprzeda¿ i prezentacja ofert dla klientów powinna byæ dostêpna „zawsze” 
A wiêc mam dla Ciebie wyzwanie! 

Zadanie:

 
8.1 Przeanalizuj swoj¹ architekturê aplikacji i zdecyduj, czy i w którym miejscu umieœci³byœ wszystkie poznane typy sk³adowania danych. 
 
Chcia³bym byæ na powa¿nie przemyœla³, jak i kiedy warto u¿yæ Table Storage, dla jakich sytuacji dobry bêdzie Azure Search, gdzie przyda siê Cosmos DB i jak zrobiæ analitykê dziêki wszystkim opcjom, które pozna³eœ. Rozwa¿ DataWarehouse, HDInsights czy DataCatalog. Jeœli coœ gdzieœ nie pasuje, napisz o tym wprost. Decyzja musi byæ z g³ow¹ i przemyœlana. 
 
Zwróæ uwagê na cenê, ka¿dej z wybieranych us³ug. Mo¿e siê okazaæ, ¿e mo¿e zrobiæ coœ lepiej, taniej, szybciej za pomoc¹ innej us³ugi – czekam na takie propozycje. 

Dobór us³ug, z perspektywy kosztów to wa¿ny element w pracy architekta dlatego musisz nabraæ tutaj wprawy.
 
8.2 Czas na praktykê!
Powo³aj najmniejsz¹ z mo¿liwych bazê Cosmos DB. Nastêpnie spróbuj wykorzystaæ tzw. Change Feed a wiêc mo¿liwoœæ wyzwalania funkcji w reakcji na zmieniaj¹ce siê dane. 
 
Wiêcej o Change Feed mo¿esz zobaczyæ tutaj:
https://azure.microsoft.com/pl-pl/resources/videos/azure-cosmosdb-change-feed/
 
A przyk³ad zbudowania takiej funkcji zobaczysz w ramach tego linku: https://docs.microsoft.com/en-us/azure/cosmos-db/change-feed

POWODZENIA! To ju¿ 8 tydzieñ naszego Kursu!
