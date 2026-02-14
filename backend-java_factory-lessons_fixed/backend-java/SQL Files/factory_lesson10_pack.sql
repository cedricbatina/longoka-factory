-- Factory DB — Pack Leçon 10 (Kikongo) — Classes nominales
-- Généré automatiquement (chips + rules + examples)

-- Déduire platform_id & course_id depuis la leçon seed (lesson_ref_id=1)
SELECT @platform_id := platform_id, @course_id := course_id
FROM lesson_refs WHERE lesson_ref_id=1;

SET @lesson_id := 10;
SET @position := 2;
SET @lesson_group := 'kikongo';
SET @slug := 'kikongo-lecon-10-classes-nominales';
SET @title := 'Les principales classes nominales du kikongo — leçon 10';
SET @status := 'draft';
SET @visibility := 'private';

-- Créer la lesson_ref si absente
INSERT INTO lesson_refs (platform_id, course_id, lesson_id, position, lesson_group, slug, title, status, visibility)
SELECT @platform_id, @course_id, @lesson_id, @position, @lesson_group, @slug, @title, @status, @visibility
WHERE NOT EXISTS (
  SELECT 1 FROM lesson_refs WHERE platform_id=@platform_id AND course_id=@course_id AND lesson_id=@lesson_id
);

SET @lr := (SELECT lesson_ref_id FROM lesson_refs WHERE platform_id=@platform_id AND course_id=@course_id AND lesson_id=@lesson_id LIMIT 1);

-- Nettoyage (permet de rejouer le script sans doublons)
DELETE FROM lesson_rules WHERE lesson_ref_id=@lr;
DELETE FROM examples    WHERE lesson_ref_id=@lr;
DELETE FROM chips       WHERE lesson_ref_id=@lr;
DELETE FROM lesson_atoms WHERE lesson_ref_id=@lr;

-- Types par défaut (on recatégorisera plus tard si besoin)
SET @ct := (SELECT MIN(chip_type_id) FROM chip_types);
SET @rt := (SELECT MIN(rule_type_id) FROM rule_types);
SET @imp := (SELECT importance_id FROM importance_levels WHERE code='core' LIMIT 1);


-- Chips
INSERT INTO chips (lesson_ref_id, chip_type_id, title, content_md)
VALUES
(@lr, @ct, 'Objectif & contexte', '👋 Yenge ! 🌍 Objectif de la leçon : comprendre et maîtriser le système des classes nominales du kikongo classique :
  repérer les préfixes nominaux (singulier/pluriel), appliquer les règles
  d’ accord nominal, adjectival et verbal, et connaître les usages les plus fréquents.

Comme dans de nombreuses langues bantoues, le kikongo classe les substantifs selon leur préfixe nominal . Ces classes structurent la phrase et codent notamment le nombre (singulier/pluriel) ainsi que les accords à l’écrit comme à l’oral.

👉 Lancement : on pose les bases des classes nominales ? Allons-y !'),
(@lr, @ct, 'Vous allez apprendre', '- ✅ Définir ce qu’est une classe nominale .
- ✅ Identifier les préfixes nominaux au singulier et au pluriel.
- ✅ Associer correctement singulier ↔ pluriel pour chaque classe.
- ✅ Réaliser les accords dans des phrases simples.
- ✅ Reconnaître les variantes (ex. n-zi / n-n) et éviter les confusions courantes.'),
(@lr, @ct, 'Pourquoi c’est utile', '- 🌱 Vous gagnez en précision et en fluidité dès vos premières phrases.
- 🧭 Vous posez les bases pour la conjugaison, la syntaxe et le lexique.
- 🤝 Vous êtes compris partout, malgré les variantes régionales.

💡 Ressource utile : explorez aussi Lexikongo ,
  notre lexique kikongo-français-anglais compagnon de ce cours.'),
(@lr, @ct, 'Définition & liste des classes nominales', 'Une classe de noms, également désignée par catégorie nominale ou catégorie de substantif, représente un concept linguistique qui vise à regrouper des termes partageant des traits similaires et remplissant une fonction grammaticale commune en tant que noms dans une langue donnée. Les noms englobent généralement des personnes, des lieux, des objets, des concepts, des idées, etc.
En kikongo, les classes nominales s''appellent : ma buundu maa zi nkuumbu
buundu - ma buundu = collection - s , organisation - s , groupe - s , société - s
Les classes nominales contiennent des noms ou mots, que nous appelons des substantifs, zi nkuumbu en kikongo. Elles revêtent une importance cruciale, car elles impactent la syntaxe et la grammaire. Comprendre ces classes nominales ou ma buundu est essentiel pour maîtriser l''utilisation et former de nouvelles expressions.
Par ailleurs, l''absence d''articles pour déterminer le genre est une particularité notable en kikongo. Au lieu d''utiliser des articles, on emploie des préfixes nominaux. L''usage de ces préfixes nominaux varie selon les classes nominales. En effet, en kikongo, les classes nominales et les préfixes sont au cœur de la langue.
Le décompte des classes nominales dépasse 24 , d''après la classification de Meinhof. Cependant, nous nous baserons dans ce cours sur l''étude des neuf classes les plus courantes.
Elles suivent le schéma : "singulier - pluriel". Les classes nominales étudiées dans ce cours sont les suivantes :
- n - zi ou n - n
- mu - ba
- mu - mi
- di - ma
- ki - bi
- bu - ma
- lu - tu
- ku - ma
- fi - bi
**💡 Remarques**
La classification proposée dans ce cours est celle établie par Dereau, d''après la classification de Meinhof. Les classes sont nommées à partir de leurs préfixes singulier et pluriel.
En kikongo, l''identification de la classe nominale à laquelle appartient un nom ou un substantif repose sur son préfixe nominal singulier ou pluriel.
En kikongo, les préfixes nominaux s''appellent :
mu yikilua - mi yikilua = préfixe - s nominal(-aux) , article - s
C''est-à-dire qu''on reconnaît une classe nominale par les préfixes singulier et pluriel du substantif. Il n''est pas nécessaire au début de connaître exactement le contenu des classes nominales à l''avance. Ce qu''il faut retenir ici, c''est que le préfixe nominal d''un substantif désigne déjà la classe à laquelle ce substantif ou mot appartient.
Les préfixes nominaux équivalent aux articles définis et indéfinis du français, au singulier et au pluriel. Ils traduisent :
1. Les articles indéfinis : singulier : un , une pluriel : des
2. Les articles définis : singulier : l'' , le , la pluriel : les
En kikongo, les trois premières classes nominales : les classes n - zi ou n - n , mu - ba et mu - mi diffèrent quelque peu des autres classes, comme nous le verrons tout au long de ce cours de kikongo classique. Étudions en détail le contenu de ces différentes classes nominales.'),
(@lr, @ct, 'Résumé des préfixes nominaux', '📌 *Note importante*
- La forme **baa** qu’on voit parfois (ex. *ba ana baa ngombe*) n’est **pas** un préfixe de classe : le préfixe est **ba-**.
- Les sous-classes à garder en tête : **lu - n** et **lu - ma** (selon les mots / régions).

| Classe | SG | PL |
|---|---|---|
| n - zi ou bien n - n | n | n ou zi |
| mu - ba | mu | ba |
| mu - mi | mu | mi |
| di - ma | di | ma |
| ki - bi | ki | bi |
| bu - ma | bu | ma |
| lu - tu | lu | tu |
| ku - ma | ku | ma |
| fi - bi | fi | bi |
'),
(@lr, @ct, 'La classe nominale n - zi', 'En kikongo, les trois premières classes nominales : les classes n - zi ou n - n , mu - ba et mu - mi diffèrent quelque peu des autres classes, comme nous le verrons tout au long de ce cours de kikongo classique. Étudions en détail le contenu de ces différentes classes nominales.
La classe nominale ou buundu dia n - zi ou n - n est une classe bien garnie et assez complexe. Les préfixes nominaux singulier et pluriel des substantifs de cette classe sont respectivement :
1. n
2. zi ou n
Le pluriel de ces substantifs s''obtient en ajoutant le préfixe zi devant le substantif au singulier. Le pluriel peut également se construire sans le préfixe zi . Le singulier dans ce cas est identique au pluriel.
👉 Pour la classe nominale n - zi ou n - n , le pluriel se construit de deux manières. Dans ce cours, nous privilégions le pluriel avec n - zi , pour plus de facilité d''apprentissage.
⚠️ Attention à la position du n !
Cette classe n - zi englobe :
- Les noms des corps célestes et des phénomènes naturels n za - zi nza = univers , cosmos m pinanza - zi mpinanza = planète - s n zazi - zi nzazi = un éclair , tonnerre , les éclairs , lors d''un orage n goonda - zi ngoonda = lune - s , mois , etc. n taangu - zi ntaangu = le temps , heure - s , période - s , moment - s , etc. m vula - zi mvula = pluie - s , saison - s , âge - s , etc. m bumba = le soleil
- Beaucoup de noms d''animaux n go - zi ngo = léopard - s n zawu - zi nzawu = éléphant - s m bua - zi mbua = chien - s m buuma - zi mbuuma = chat - s
- Les substantifs dérivés des verbes et qui désignent l''action du verbe. n sa - zi nsa = action - s , action - s de faire Cette expression est un substantif dérivé du verbe : ku sa = faire n dia = action de manger Cette expression est un substantif dérivé du verbe : ku dia = manger
- Les substantifs dérivés des verbes et qui désignent la manière de poser l''action n siilu - zi nsiilu = manière - s de faire n diilu - zi ndiilu = manière - s de manger
- De nombreux substantifs divers m pavi - zi mpavi = pelle - s , bêche - s n goyi - zi ngoyi = personne - s étranger - ère - s
Cette classe est la plus difficile à reconnaître :
1. Primo à cause de l''omniprésence du n dans le kikongo.
2. Secundo du fait que le n mute en m devant certaines consonnes, telles que : b p f m v'),
(@lr, @ct, 'La classe nominale mu - ba', 'La classe nominale mu - ba contient exclusivement des substantifs qui représentent des personnes ou des groupes de personnes. Cette classe ne comprend pas beaucoup de substantifs ou mots.
Cette classe est plus facile à reconnaître que la classe n - zi .
- mu ana - ba ana = enfant - s Dans certaines régions, le pluriel de ce mot s''emploie différemment : mu ana - ba ala = enfant - s
- mu ntu - ba ntu = être - s humain - s
- mu kento - ba kento = femme - s 💡 Remarques Le substantif mu kento peut s''élider et s''employer : n'' kento Le substantif bakala = homme , est une exception. Bien qu''il représente une personne, il s''emploie au singulier comme un substantif de la classe di - ma . Au pluriel, on emploie ba bakala , comme un substantif de la classe mu - ba'),
(@lr, @ct, 'La classe nominale mu - mi', 'Cette classe contient divers substantifs.
- Les nomina agentium ou substantifs d''agent Cette classe comprend des substantifs d''agent ou nomina agentium qui indiquent une fonction et sont dérivés des verbes. Considérons le substantif mu long i qui veut dire toute personne qui enseigne ou conseille. Ce substantif est dérivé du verbe : ku long a = enseigner , conseiller . Au pluriel mi long i . mu kang i = n'' kang i Ce nomen agentis ou substantif d''agent nous donne au pluriel mi kang i = ceux ou celles qui lient, attachent, ferment. Ce substantif vient du verbe : ku kanga = lier, attacher, fermer Pour obtenir ces substantifs de personnes, dérivés indiquant la fonction, il suffit d''ajouter le préfixe n'' au radical du verbe et de changer la terminaison a de l''infinitif en i . Enfin, avec ce mot élidé formé avec la nasale n'' , on peut alors faire une prothèse pour avoir le préfixe mu . Comme le verbe ku yiba = voler , au de sens de voleur mu yib i = voleur 💡 Remarques Enfin, un substantif de la classe n - n peut être confondu avec un substantif de la classe mu - ba ou un substantif de la classe mu - mi , en raison du phénomène d''élision. Afin de bien comprendre l''élision du préfixe mu , considérons les substantifs suivants : mu kento est un substantif de la classe mu - ba mu kento est, après élision, égal à n'' kento mu long i est un substantif dérivé de la classe mu - mi mu long i , après élision devient n'' long i = un conseiller , le professeur , une instructrice , etc. mu kub i est un substantif dérivé du verbe : ku kuba = tisser mu kub i , après élision devient n'' kub i = tisserand etc. En gros, pour ne pas confondre certains substantifs des classes nominales mu - ba et mu - mi , après le phénomène d''élision, on emploie l''apostrophe après la nasale n . Cette construction avec l''apostrophe est phonétiquement correcte. Pour information : n ienie - zi nienie = apostrophe - s , d''après l'' Appendix to the Dictionary and Grammar of the Kongo Language , As spoken at San Salvador, the Ancient Capital of the Old Kongo Empire, West Africa de W. Holman Bentley. n tentia - zi ntentia = apostrophe - s , D''après le lexique du Mandombé, tel qu''établi par le professeur Wabeladio Payi Pour prononcer un tel substantif, il suffit de nasaliser le moins possible la nasale n'' ou m'' et de prononcer la première syllabe du radical sur un ton aigu.
- Les substantifs représentant des animaux. mu nkanga - mi nkanga = truie - s en lactation , une truie qui a mis bas mu nkengi - mi nkengi = crevette - s , du fleuve Kongo
- Les substantifs représentant des arbres. mu manga - mi manga = manguier - s mu ba - mi ba = palmier - s
- Les substantifs divers concrets et abstraits mu kaaka - mi kaaka = totalité - s , somme - s mu kakala - mi kakala = nombre - s impair - s mu nkela - mi nkela = basson - s , instrument de musique La classe mu - mi est très riche et comprend une variété de substantifs.'),
(@lr, @ct, 'La classe nominale di - ma', 'La classe nominale di - ma est très variée. Cette classe est assez complexe à reconnaître. De nombreux substantifs de cette classe n''emploient pas de préfixe nominal singulier. Elle comporte les substantifs désignant des choses concrètes, les substantifs ou noms de certains fruits, des noms des choses abstraites, certaines parties du corps, les groupes humains etc...
- di iki - ma iki = œuf - s
- kongo - ma kongo = chef - s puissant - s , seigneur - s , femme - s puissante - s , homme - s puissant - s , mort - e depuis peu ou depuis longtemps. Ce substantif est un titre pour désigner un ou une mu isi kongo mort(e) récemment ou depuis longtemps, et qui de son vivant se serait distingué(e) par ses hautes valeurs morales et spirituelles.
- vata - ma vata = village - s , campagne - s , pays
- kutu - ma kutu = oreille - s
- di mpa - ma mpa = pain - s
- di buundu - ma buundu = organisation - s , assemblée - s
- laala - ma laala = orange - s
- di nkondi - ma nkondi = banane - s . Dans certaines régions, on dit aussi di nkondo - ma nkondo
Cette classe nominale contient divers substantifs difficilement classables par catégorie.'),
(@lr, @ct, 'La classe nominale ki - bi', 'La classe ki - bi est également une classe qui comporte plusieurs substantifs variés. Comme la classe n - zi , elle comporte des noms de choses matérielles, des noms indiquant une dignité et bien plus. On compte aussi des noms désignant un état, une qualité ou un défaut.
Cette classe regroupe aussi les noms des langues et certains substantifs dérivés d''autres substantifs ou des verbes, comme les diminutifs dérivés d''autres substantifs.
- ki mfumu - bi mfumu = autorité - s , au sens de responsabilité
- ki mbevo - bi mbevo = maladie - s
- ki kata - bi kata = personne - s handicapée - s , physiquement
- ki sanu - bi sanu = peigne - s Le mot kisanu vient du verbe : ku sana = peigner .
- ki mpala = jalousie Cette expression s''emploie souvent au singulier, car elle désigne une émotion.
- ki nzo-nzo - bi nzo-nzo = maisonnette - s Ces substantifs diminutifs de la classe ki - bi se forment avec le redoublement de ce substantif précédé du préfixe nominal.
Il existe une autre formule, quelque peu spéciale pour construire les diminutifs des substantifs comprenant une syllabe. Nous verrons dans une leçon ultérieure, intitulée : Les principaux substantifs dérivés du kikongo
Nous avons néanmoins vu dans la précédente leçon un de ces diminutifs spéciaux :
ki ntokolonto - bi ntokolonto = petite - s rivière - s'),
(@lr, @ct, 'La classe nominale bu - ma', 'La classe nominale bu - ma est une classe bien fournie. Elle comporte des substantifs divers et d''une manière générale, les noms abstraits sans pluriel qui désignent une qualité ou un défaut.
**🌱 Exemples**
- bu atu - ma atu = pirogue - s
- bu ko - ma ko = beaux-parents , belles-sœurs , etc.
- bu molo = paresse
- bu mpofo = cécité
- bu koka = paralysie , handicap
- bu ngimba - ma ngimba = musique - s , mélodie - s
- bu mpala = jalousie
- bu ntunta = brutalité . Dans certaines régions du Kongo, les mots de cette classe prennent le préfixe de la classe ki - bi ou celui de la classe lu - tu . Ainsi donc on peut retrouver ki mpala ou encore lu zitu .'),
(@lr, @ct, 'La classe nominale lu - tu', 'La classe nominale lu - tu est une classe très riche qui renferme une grande partie des substantifs représentant des sentiments. Elle comporte également certaines parties du corps et divers substantifs concrets et abstraits
**🌱 Exemples**
- lu zolo = amour , volonté
- lu mpampani = vantardise
- lu ve - tu ve = droit - s , permission - s , autorisation - s , etc.
- lu lendo - tu lendo = puissance - s , pouvoir - s , possibilité - s , etc.
Cette classe a deux sous-classes qui sont : la classe lu - n et la classe lu - ma
**Les substantifs de la sous-classe lu - n**
- lu zala - zi nzala = ongle - s
- lu vanga - zi mpanga = verbe - s , barre - s , ligne - s , etc.
**Les substantifs de la sous-classe lu - ma**
- lu vuku - ma vuku = interruption - s
- lu ve - ma ve = herbe - s , tige - s , etc.'),
(@lr, @ct, 'La classe nominale ku - ma', 'Cette classe n''est pas très riche. Elle comprend entre autres des substantifs concrets comme des parties du corps.
**🌱 Exemples**
- ku ulu - ma alu = jambe - s
- ku oko - ma oko = main - s'),
(@lr, @ct, 'La classe nominale fi', 'Cette classe est très riche. C''est la classe où l''on retrouve les diminutifs. Ces diminutifs sont dérivés d''autres substantifs. Elle comprend donc une grande quantité de substantifs.
Elle est assez facile à reconnaître. Pour les diminutifs des substantifs représentant des êtres vivants, on peut employer l''expression mu ana . L''emploi de la forme contractée, mu a est aussi possible.
**🌱 Exemples**
- fi nzo = maisonnette muana ngombe = un veau mu a mbuuma = un chaton
- fi n''tu = petite tête
- muana bakala = jeune homme Comme nous l''avons vu ci-dessus, la classe ki - bi compte également des diminutifs. La classe fi emploie le préfixe nominal pluriel de la classe ki - bi . On emploie donc le préfixe pluriel bi , pour le pluriel de la classe fi , et on redouble le substantif sur lequel se porte la diminution. Dans le cas où l''expression mu ana ou mu a est employée, on emploie son pluriel : ba ana
- bi mbua - mbua = des chiots
- bi nzo - nzo = des maisonnettes
- ba ana ngombe = des veaux La forme suivante est correcte et recommandée. ba ana baa ngombe = des veaux ou bien les enfants de la vache
Dans cette formule, nous avons employé l''expression baa qui est un préfixe nominal d''accord. Nous étudierons ce genre de préfixe dans une leçon ultérieure intitulée Les préfixes nominaux d''accord du kikongo Ce qu''il faut retenir ici, c''est que la classe nominale fi forme ses diminutifs de plusieurs manières :
1. Au singulier : fi ou bien mu ana ou bien mu a + le substantif
2. Au pluriel : bi + deux fois le substantif ou bien ba ana + le substantif Ou encore mieux ba ana + baa + le substantif'),
(@lr, @ct, 'Lexique', '**⚠️ Convention des gloses FR**
Comme nous l''avons vu dans la leçon précédente, dans les gloses françaises de ce programme :
- • « - s » = pluriel régulier (ex. chien - s → chiens ) ;
- • « - x » = pluriel en -x (ex. bateau - x → bateaux ) ;
Les paires kikongo sont notées « singulier - pluriel ».
Les éléments naturels
- mu toto = la Terre , terre - s
- ma amba = eau - x , au sens d''énergie Un autre mot est : ma za = eau - x , au sens visible Ce substantif s''emploie toujours au pluriel.
- mu pepe - mi pepe = air - s
- m bawu = feu - x , au sens d''énergie Un autre mot est : tiya = feu - x , au sens visible Ce substantif s''emploie toujours au pluriel.
- mu ludi - mi ludi = toit - s
- ki lumbu - bi lumbu = jour - s
- ki lumbu ki = aujourd''hui , Littéralement, cette expression se traduit par : ce jour-ci On peut omettre le préfixe nominal ki , comme suit : lumbu ki = aujourd''hui , etc.
- ma zono ou zono = hier
- ma zuzi ou zuzi = avant-hier , toute la période plus tôt qu''hier ma zuzi ou zuzi , désignent en réalité, tout le temps avant-hier et plus tôt.
- mbazi = demain
- lu mingu - tu mingu = semaine - s
- n talu - zi ntalu = prix , nombre - s , valeur - s
- n saba - zi nsaba = jardin - s
- ki koozo - bi koozo = salle - s de bains , toilette - s
- ki kuuku - bi kuuku = cuisine - s , foyer - s
- ki mbombo - bi mbombo = véranda - s , balcon - s
Autres substantifs utiles.
- n zaaza - zi nzaaza = bateau - x
- n gaandu - zi ngaandu = crocodile - s , caïman - s
- n deki - zi ndeki = avion - s
- mu bu - mi bu = mer - s
- m finda - zi mfida = forêt - s
- mu ongo - mi ongo = montagne - s'),
(@lr, @ct, 'Exercices 2', '- A - Les substantifs suivants sont au singulier et au pluriel. Déterminez leur classe nominale et complétez-les avec les préfixes nominaux appropriés m'' vu - _____ vu = année - s _____ boma - m boma = python - s m pidi - _____ pidi = vipère - s _____ wutuku - tu wutuku = généalogie - s _____ ngoyongo - bi ngoyongo = menotte - s , chaîne - s _____ sikidisu - tu sikidisu = diplôme - s , certificat - s , etc. _____ kuala - zi nkuala = canal - canaux ki mbila - _____ mbila = sifflet - s n iosi - _____ niosi = abeille - s
- B - Complétez les substantifs ci-dessous avec les préfixes nominaux appropriés : di inu - _____ inu = dent - s _____ leembo - mi leembo = doigt - s _____ siingu - n siingu = cou - s _____ koba - bi koba = lèvre - s m pivi - _____ pivi = orphelin - s , intrus , genre unique _____ ambu - ma ambu = chose - s , affaire - s _____ poofi - zi mpoofi = délégué - s , ambassadeur - s , représentant - s _____ mpuni - bi mpuni = imitation - s , fausseté - s , fausse - s représentation - s , d''une marque par exemple n gika - _____ gika = supplément - s , affixe - s en grammaire
- C - Pour les substantifs suivants, déterminez leur forme selon qu''ils sont au singulier ou au pluriel. Si un substantif est au singulier, donnez sa forme au pluriel. Si un substantif est au pluriel, donnez sa forme au singulier. n gudi n talu mi samu m finda ba kento mu kelo fi ngulu bu atu mu ana ki sielo mu lele
- D - Déterminez le singulier et le pluriel en kikongo des mots en français suivants : une femme un manguier un peigne un chiot un pain un voleur une banane une maisonnette un œuf une jambe un chien beau-parent une demoiselle un ongle être humain une petite mangue'),
(@lr, @ct, 'Corrections des exercices 2', '1. Énoncé A - Les substantifs suivants sont au singulier et au pluriel. Déterminez leur classe nominale et complétez-les avec les préfixes nominaux appropriés Corrigé m'' vu - mi vu = année - s m boma - m boma = python - s m pidi - m pidi = vipère - s m pidi - zi mpidi = vipère - s lu wutuku - tu wutuku = généalogie - s ki ngoyongo - bi ngoyongo = menotte - s , chaîne - s lu sikidisu - tu sikidisu = diplôme - s , certificat - s , etc. n kuala - zi nkuala = canal - canaux , chaîne , de radio par exemple ki mbila - bi mbila = sifflet - s n iosi - n iosi = abeille - s n iosi - zi niosi = abeille - s
2. Énoncé B - Complétez les substantifs ci-dessous avec les préfixes nominaux appropriés : Corrigé di inu - ma inu = dent - s mu leembo - mi leembo = doigt - s n siingu - n siingu = cou - s ki koba - bi koba = lèvre - s m pivi - m pivi = orphelin - s , intrus , genre unique di ambu - ma ambu = chose - s , affaire - s m poofi - zi mpoofi = délégué - s , ambassadeur - s , représentant - s ki mpuni - bi mpuni = imitation - s , fausseté - s , fausse représentation , d''une marque par exemple n gika - n gika = supplément - s , rajout - s , affixe - s en grammaire
3. Énoncé C - Pour les substantifs suivants, déterminez leur forme selon qu''ils sont au singulier ou au pluriel. Si un substantif est au singulier, donnez sa forme au pluriel. Si un substantif est au pluriel, donnez sa forme au singulier. Corrigé Le substantif n gudi appartient à la classe n - n . Sans autre précision, il peut être soit au singulier soit au pluriel. Les deux formulations suivantes sont correctes n gudi - n gudi = mère - s , radicale - s , important - s , essentielle - s , réel - s , etc. n gudi - zi ngudi = mère - s , radicale - s , important - s , essentielle - s , réel - s , etc. Le substantif n talu appartient à la classe n - n . Sans autre précision, il peut être soit au singulier soit au pluriel. Les deux formulations suivantes sont correctes n talu - n talu = prix , nombre - s , etc. n talu - zi ntalu = prix , nombre - s , etc. mu samu - mi samu = affaire - s , problème - s , préoccupation - s m finda étant de la classe n - n , les deux formulations suivantes sont correctes : m finda - m finda = forêt - s m finda - zi mfinda = forêt - s mu kento - ba kento = femme - s mu kelo - mi kelo = fontaine - s d''eau fi ngulu - bi ngulu-ngulu = porcelet - s On peut aussi utiliser l''expression mu ana ou mu a, comme suit : mu ana ngulu - ba ana ngulu-ngulu = porcelet - s mu ana a ngulu - ba ana baa ngulu-ngulu = porcelet - s mu a ngulu - ba ana baa ngulu-ngulu = porcelet - s bu atu - ma atu = pirogue - s mu ana - ba ana = enfant - s ki sielo - bi sielo = serviteur - s mu lele - mi lele = habit - s , tissu - s
4. Énoncé D - Déterminez le singulier et le pluriel en kikongo des mots en français suivants : Corrigé une femme = mu kento - ba kento un manguier = mu manga - mi manga un peigne = ki sanu - bi sanu un chiot = fi mbua - bi mbua-mbua un pain = di mpa - ma mpa un voleur = mu yibi - mi yibi une banane = di nkondi - ma nkondi une maisonnette = fi nzo - bi nzo-nzo un œuf = di iki - ma iki une jambe = ku ulu - ma alu Ce substantif au pluriel devrait s''employer ma ulu. Mais à l''oral, on entend souvent ma alu un chien = m bua - m bua un chien = m bua - zi mbua beau-parent = bu ko - ma ko une demoiselle = fi kento - bi kentokento un ongle = lu zala - zi nzala être humain = mu ntu - ba ntu une petite mangue = fi manga - bi mangamanga'),
(@lr, @ct, 'Résumé final', '🧭 Cette leçon vous a permis de découvrir les principales classes nominales du kikongo , regroupées selon leurs préfixes nominaux au singulier et au pluriel : n-n, mu-ba, mu-mi, di-ma, ki-bi, bu-ma, lu-tu, ku-ma et fi-bi.

🧩 Ces classes structurent le kikongo et sont au cœur de son système grammatical. Savoir les reconnaître est indispensable pour maîtriser les accords dans les phrases.

📌 Certains mots n’utilisent pas toujours de préfixe au singulier, rendant leur identification plus complexe. La pratique et l’écoute du kikongo sont donc essentielles pour les assimiler.

🌐 N''hésitez pas à consulter des ressources complémentaires telles que fr.wikikongo.net pour explorer davantage la richesse culturelle de la langue kongo.');

-- Rules + linking
INSERT INTO rules (rule_type_id, title, statement_md, pattern_json, notes_md)
SELECT @rt, 'Définition: classe nominale', 'Une **classe nominale** regroupe des substantifs qui partagent un **préfixe nominal** (SG/PL) et qui déclenchent des **accords** dans la phrase (déterminants, adjectifs, parfois verbes).', NULL, 'Le préfixe est morphologique (au début du nom).'
WHERE NOT EXISTS (SELECT 1 FROM rules WHERE title='Définition: classe nominale');

INSERT INTO lesson_rules (lesson_ref_id, rule_id, importance_id)
SELECT @lr, r.rule_id, @imp FROM rules r
WHERE r.title='Définition: classe nominale'
  AND NOT EXISTS (SELECT 1 FROM lesson_rules lr2 WHERE lr2.lesson_ref_id=@lr AND lr2.rule_id=r.rule_id);

INSERT INTO rules (rule_type_id, title, statement_md, pattern_json, notes_md)
SELECT @rt, 'Singulier ↔ pluriel: principe', 'En kikongo, beaucoup de noms ont un couple **SG ↔ PL** qui se fait principalement par **changement de préfixe** (ex. *mu-* → *ba-*, *di-* → *ma-*, etc.).', NULL, 'Apprendre les couples de classes = gagner en fluidité et en accords.'
WHERE NOT EXISTS (SELECT 1 FROM rules WHERE title='Singulier ↔ pluriel: principe');

INSERT INTO lesson_rules (lesson_ref_id, rule_id, importance_id)
SELECT @lr, r.rule_id, @imp FROM rules r
WHERE r.title='Singulier ↔ pluriel: principe'
  AND NOT EXISTS (SELECT 1 FROM lesson_rules lr2 WHERE lr2.lesson_ref_id=@lr AND lr2.rule_id=r.rule_id);

INSERT INTO rules (rule_type_id, title, statement_md, pattern_json, notes_md)
SELECT @rt, 'Classe n-zi / n-n: pluralisation', 'Pour la classe **n-zi** (ou **n-n**), le singulier prend souvent **n-** et le pluriel se fait soit en ajoutant **zi-**, soit en gardant **n-** (selon les mots / régions).', NULL, 'Attention à la position du *n* et aux variations régionales.'
WHERE NOT EXISTS (SELECT 1 FROM rules WHERE title='Classe n-zi / n-n: pluralisation');

INSERT INTO lesson_rules (lesson_ref_id, rule_id, importance_id)
SELECT @lr, r.rule_id, @imp FROM rules r
WHERE r.title='Classe n-zi / n-n: pluralisation'
  AND NOT EXISTS (SELECT 1 FROM lesson_rules lr2 WHERE lr2.lesson_ref_id=@lr AND lr2.rule_id=r.rule_id);

INSERT INTO rules (rule_type_id, title, statement_md, pattern_json, notes_md)
SELECT @rt, 'Assimilation du n', 'Règle d’euphonie fréquente : le **n** se réalise souvent **m** devant une consonne bilabiale/labio‑dentale (b, p, f, m, v).', NULL, 'Ex. typiques : n + b → mb…, n + p → mp…, etc. (utile pour QC/segmentation).'
WHERE NOT EXISTS (SELECT 1 FROM rules WHERE title='Assimilation du n');

INSERT INTO lesson_rules (lesson_ref_id, rule_id, importance_id)
SELECT @lr, r.rule_id, @imp FROM rules r
WHERE r.title='Assimilation du n'
  AND NOT EXISTS (SELECT 1 FROM lesson_rules lr2 WHERE lr2.lesson_ref_id=@lr AND lr2.rule_id=r.rule_id);

INSERT INTO rules (rule_type_id, title, statement_md, pattern_json, notes_md)
SELECT @rt, 'Classe mu-ba: humains', 'La classe **mu‑ba** contient principalement des substantifs humains/agents. Le pluriel se fait avec **ba‑**.', NULL, 'Certains mots peuvent perdre *mu-* (élision n’ / formes lexicalisées).'
WHERE NOT EXISTS (SELECT 1 FROM rules WHERE title='Classe mu-ba: humains');

INSERT INTO lesson_rules (lesson_ref_id, rule_id, importance_id)
SELECT @lr, r.rule_id, @imp FROM rules r
WHERE r.title='Classe mu-ba: humains'
  AND NOT EXISTS (SELECT 1 FROM lesson_rules lr2 WHERE lr2.lesson_ref_id=@lr AND lr2.rule_id=r.rule_id);

INSERT INTO rules (rule_type_id, title, statement_md, pattern_json, notes_md)
SELECT @rt, 'Diminutifs et ''baa''', 'Les diminutifs peuvent s’exprimer avec **fi‑/bi‑** ou via des constructions du type **muana X** (sing.) / **ba ana baa X** (pl.).', NULL, '**baa n’est pas un préfixe de classe** : c’est une forme de liaison (ba + a) dans l’expression.'
WHERE NOT EXISTS (SELECT 1 FROM rules WHERE title='Diminutifs et ''baa''');

INSERT INTO lesson_rules (lesson_ref_id, rule_id, importance_id)
SELECT @lr, r.rule_id, @imp FROM rules r
WHERE r.title='Diminutifs et ''baa'''
  AND NOT EXISTS (SELECT 1 FROM lesson_rules lr2 WHERE lr2.lesson_ref_id=@lr AND lr2.rule_id=r.rule_id);

INSERT INTO rules (rule_type_id, title, statement_md, pattern_json, notes_md)
SELECT @rt, 'Sous-classes de lu-', 'La classe **lu‑tu** admet des sous‑classes importantes dans le cours : **lu‑n** et **lu‑ma** (selon les lexèmes / régions).', NULL, 'À garder en tête pour les tables et futurs jeux.'
WHERE NOT EXISTS (SELECT 1 FROM rules WHERE title='Sous-classes de lu-');

INSERT INTO lesson_rules (lesson_ref_id, rule_id, importance_id)
SELECT @lr, r.rule_id, @imp FROM rules r
WHERE r.title='Sous-classes de lu-'
  AND NOT EXISTS (SELECT 1 FROM lesson_rules lr2 WHERE lr2.lesson_ref_id=@lr AND lr2.rule_id=r.rule_id);

INSERT INTO rules (rule_type_id, title, statement_md, pattern_json, notes_md)
SELECT @rt, 'Modélisation CCVV (voyelles longues)', 'Pour que le QC dérive correctement **CCVV**, une voyelle longue doit être encodée en **double graphème** dans `atom_grapheme_seq` (aa, ee, ii, oo, uu).', NULL, 'Ex. *ndaa* = n d a a → dérivé = **ccvv**.'
WHERE NOT EXISTS (SELECT 1 FROM rules WHERE title='Modélisation CCVV (voyelles longues)');

INSERT INTO lesson_rules (lesson_ref_id, rule_id, importance_id)
SELECT @lr, r.rule_id, @imp FROM rules r
WHERE r.title='Modélisation CCVV (voyelles longues)'
  AND NOT EXISTS (SELECT 1 FROM lesson_rules lr2 WHERE lr2.lesson_ref_id=@lr AND lr2.rule_id=r.rule_id);

-- Examples
INSERT INTO examples (lesson_ref_id, kg_text, fr_text, en_text, notes_md)
VALUES
(@lr, 'n za - zi nza', 'univers , cosmos', NULL, NULL),
(@lr, 'm pinanza - zi mpinanza', 'planète - s', NULL, NULL),
(@lr, 'n zazi - zi nzazi', 'un éclair , tonnerre , les éclairs , lors d''un orage', NULL, NULL),
(@lr, 'n goonda - zi ngoonda', 'lune - s , mois , etc.', NULL, NULL),
(@lr, 'n taangu - zi ntaangu', 'le temps , heure - s , période - s , moment - s , etc.', NULL, NULL),
(@lr, 'm vula - zi mvula', 'pluie - s , saison - s , âge - s , etc.', NULL, NULL),
(@lr, 'm bumba', 'le soleil', NULL, NULL),
(@lr, 'n go - zi ngo', 'léopard - s', NULL, NULL),
(@lr, 'n zawu - zi nzawu', 'éléphant - s', NULL, NULL),
(@lr, 'm bua - zi mbua', 'chien - s', NULL, NULL),
(@lr, 'm buuma - zi mbuuma', 'chat - s', NULL, NULL),
(@lr, 'n sa - zi nsa', 'action - s , action - s de faire', NULL, 'Cette expression est un substantif dérivé du verbe :'),
(@lr, 'ku sa', 'faire', NULL, NULL),
(@lr, 'n dia', 'action de manger', NULL, 'Cette expression est un substantif dérivé du verbe :'),
(@lr, 'ku dia', 'manger', NULL, NULL),
(@lr, 'n siilu - zi nsiilu', 'manière - s de faire', NULL, NULL),
(@lr, 'n diilu - zi ndiilu', 'manière - s de manger', NULL, NULL),
(@lr, 'm pavi - zi mpavi', 'pelle - s , bêche - s', NULL, NULL),
(@lr, 'n goyi - zi ngoyi', 'personne - s étranger - ère - s', NULL, NULL),
(@lr, 'mu ana - ba ana', 'enfant - s', NULL, 'Dans certaines régions, le pluriel de ce mot s''emploie différemment :'),
(@lr, 'mu ana - ba ala', 'enfant - s', NULL, NULL),
(@lr, 'mu ntu - ba ntu', 'être - s humain - s', NULL, NULL),
(@lr, 'mu kento - ba kento', 'femme - s 💡 Remarques Le substantif mu kento peut s''élider et s''employer :', NULL, NULL),
(@lr, 'n'' kento Le substantif bakala', 'homme , est une exception.', NULL, 'Bien qu''il représente une personne, il s''emploie au singulier comme un substantif de la classe di - ma . Au pluriel, on emploie ba bakala , comme un substantif de la classe mu - ba'),
(@lr, 'Le substantif bakala', 'homme , est une exception.', NULL, 'Bien qu''il représente une personne, il s''emploie au singulier comme un substantif de la classe di - ma . Au pluriel, on emploie ba bakala , comme un substantif de la classe mu - ba'),
(@lr, 'ku long a', 'enseigner , conseiller .', NULL, 'Au pluriel'),
(@lr, 'mi long i . mu kang i', 'n'' kang i Ce nomen agentis ou substantif d''agent nous donne au pluriel', NULL, NULL),
(@lr, 'mi kang i', 'ceux ou celles qui lient, attachent, ferment.', NULL, 'Ce substantif vient du verbe :'),
(@lr, 'ku kanga', 'lier, attacher, fermer Pour obtenir ces substantifs de personnes, dérivés indiquant la fonction, il suffit d''ajouter le préfixe n'' au radical du verbe et de changer la terminaison a de l''infinitif en i .', NULL, 'Enfin, avec ce mot élidé formé avec la nasale n'' , on peut alors faire une prothèse pour avoir le préfixe'),
(@lr, 'mu . Comme le verbe ku yiba', 'voler , au de sens de voleur', NULL, NULL),
(@lr, 'mu yib i', 'voleur 💡 Remarques Enfin, un substantif de la classe n - n peut être confondu avec un substantif de la classe mu - ba ou un substantif de la classe mu - mi , en raison du phénomène d''élision.', NULL, 'Afin de bien comprendre l''élision du préfixe mu , considérons les substantifs suivants : mu kento est un substantif de la classe mu - ba mu kento est, après élision, égal à n'' kento mu long i est un substantif dérivé de la classe'),
(@lr, 'mu - mi mu long i , après élision devient n'' long i', 'un conseiller , le professeur , une instructrice , etc.', NULL, NULL),
(@lr, 'mu kub i est un substantif dérivé du verbe : ku kuba', 'tisser', NULL, NULL),
(@lr, 'mu kub i , après élision devient n'' kub i', 'tisserand etc.', NULL, 'En gros, pour ne pas confondre certains substantifs des classes nominales mu - ba et mu - mi , après le phénomène d''élision, on emploie l''apostrophe après la nasale n . Cette construction avec l''apostrophe est phonétiquement correcte. Pour information :'),
(@lr, 'n ienie - zi nienie', 'apostrophe - s , d''après l'' Appendix to the Dictionary and Grammar of the Kongo Language , As spoken at San Salvador, the Ancient Capital of the Old Kongo Empire, West Africa de W.', NULL, 'Holman Bentley.'),
(@lr, 'n tentia - zi ntentia', 'apostrophe - s , D''après le lexique du Mandombé, tel qu''établi par le professeur Wabeladio Payi Pour prononcer un tel substantif, il suffit de nasaliser le moins possible la nasale n'' ou m'' et de prononcer la première syllabe du radical sur un ton aigu.', NULL, NULL),
(@lr, 'mu kang i', 'n'' kang i Ce nomen agentis ou substantif d''agent nous donne au pluriel', NULL, NULL),
(@lr, 'ku kanga', 'lier, attacher, fermer', NULL, NULL),
(@lr, 'mu long i est un substantif dérivé de la classe mu - mi mu long i , après élision devient n'' long i', 'un conseiller , le professeur , une instructrice , etc.', NULL, NULL),
(@lr, 'mu kub i , après élision devient n'' kub i', 'tisserand', NULL, NULL),
(@lr, 'n tentia - zi ntentia', 'apostrophe - s , D''après le lexique du Mandombé, tel qu''établi par le professeur Wabeladio Payi', NULL, NULL),
(@lr, 'mu nkanga - mi nkanga', 'truie - s en lactation , une truie qui a mis bas', NULL, NULL),
(@lr, 'mu nkengi - mi nkengi', 'crevette - s , du fleuve Kongo', NULL, NULL),
(@lr, 'mu manga - mi manga', 'manguier - s', NULL, NULL),
(@lr, 'mu ba - mi ba', 'palmier - s', NULL, NULL),
(@lr, 'mu kaaka - mi kaaka', 'totalité - s , somme - s', NULL, NULL),
(@lr, 'mu kakala - mi kakala', 'nombre - s impair - s', NULL, NULL),
(@lr, 'mu nkela - mi nkela', 'basson - s , instrument de musique La classe mu - mi est très riche et comprend une variété de substantifs.', NULL, NULL),
(@lr, 'mu nkela - mi nkela', 'basson - s , instrument de musique', NULL, NULL),
(@lr, 'di iki - ma iki', 'œuf - s', NULL, NULL);

INSERT INTO examples (lesson_ref_id, kg_text, fr_text, en_text, notes_md)
VALUES
(@lr, 'kongo - ma kongo', 'chef - s puissant - s , seigneur - s , femme - s puissante - s , homme - s puissant - s , mort - e depuis peu ou depuis longtemps.', NULL, 'Ce substantif est un titre pour désigner un ou une mu isi kongo mort(e) récemment ou depuis longtemps, et qui de son vivant se serait distingué(e) par ses hautes valeurs morales et spirituelles.'),
(@lr, 'vata - ma vata', 'village - s , campagne - s , pays', NULL, NULL),
(@lr, 'kutu - ma kutu', 'oreille - s', NULL, NULL),
(@lr, 'di mpa - ma mpa', 'pain - s', NULL, NULL),
(@lr, 'di buundu - ma buundu', 'organisation - s , assemblée - s', NULL, NULL),
(@lr, 'laala - ma laala', 'orange - s', NULL, NULL),
(@lr, 'di nkondi - ma nkondi', 'banane - s .', NULL, 'Dans certaines régions, on dit aussi di nkondo - ma nkondo'),
(@lr, 'ki mfumu - bi mfumu', 'autorité - s , au sens de responsabilité', NULL, NULL),
(@lr, 'ki mbevo - bi mbevo', 'maladie - s', NULL, NULL),
(@lr, 'ki kata - bi kata', 'personne - s handicapée - s , physiquement', NULL, NULL),
(@lr, 'ki sanu - bi sanu', 'peigne - s Le mot kisanu vient du verbe :', NULL, NULL),
(@lr, 'ku sana', 'peigner .', NULL, NULL),
(@lr, 'ki mpala', 'jalousie', NULL, 'Cette expression s''emploie souvent au singulier, car elle désigne une émotion.'),
(@lr, 'ki nzo-nzo - bi nzo-nzo', 'maisonnette - s Ces substantifs diminutifs de la classe ki - bi se forment avec le redoublement de ce substantif précédé du préfixe nominal.', NULL, NULL),
(@lr, 'bu atu - ma atu', 'pirogue - s', NULL, NULL),
(@lr, 'bu ko - ma ko', 'beaux-parents , belles-sœurs , etc.', NULL, NULL),
(@lr, 'bu molo', 'paresse', NULL, NULL),
(@lr, 'bu mpofo', 'cécité', NULL, NULL),
(@lr, 'bu koka', 'paralysie , handicap', NULL, NULL),
(@lr, 'bu ngimba - ma ngimba', 'musique - s , mélodie - s', NULL, NULL),
(@lr, 'bu mpala', 'jalousie', NULL, NULL),
(@lr, 'bu ntunta', 'brutalité .', NULL, 'Dans certaines régions du Kongo, les mots de cette classe prennent le préfixe de la classe ki - bi ou celui de la classe lu - tu . Ainsi donc on peut retrouver ki mpala ou encore lu zitu .'),
(@lr, 'lu zolo', 'amour , volonté', NULL, NULL),
(@lr, 'lu mpampani', 'vantardise', NULL, NULL),
(@lr, 'lu ve - tu ve', 'droit - s , permission - s , autorisation - s , etc.', NULL, NULL),
(@lr, 'lu lendo - tu lendo', 'puissance - s , pouvoir - s , possibilité - s , etc.', NULL, NULL),
(@lr, 'lu zala - zi nzala', 'ongle - s', NULL, NULL),
(@lr, 'lu vanga - zi mpanga', 'verbe - s , barre - s , ligne - s , etc.', NULL, NULL),
(@lr, 'lu vuku - ma vuku', 'interruption - s', NULL, NULL),
(@lr, 'lu ve - ma ve', 'herbe - s , tige - s , etc.', NULL, NULL),
(@lr, 'ku ulu - ma alu', 'jambe - s', NULL, NULL),
(@lr, 'ku oko - ma oko', 'main - s', NULL, NULL),
(@lr, 'fi nzo', 'maisonnette', NULL, NULL),
(@lr, 'muana ngombe', 'un veau', NULL, NULL),
(@lr, 'mu a mbuuma', 'un chaton', NULL, NULL),
(@lr, 'fi n''tu', 'petite tête', NULL, NULL),
(@lr, 'muana bakala', 'jeune homme', NULL, 'Comme nous l''avons vu ci-dessus, la classe ki - bi compte également des diminutifs. La classe fi emploie le préfixe nominal pluriel de la classe ki - bi . On emploie donc le préfixe pluriel bi , pour le pluriel de la classe fi , et on redouble le substantif sur lequel se porte la diminution. Dans le cas où l''expression mu ana ou mu a est employée, on emploie son pluriel : ba ana'),
(@lr, 'bi mbua - mbua', 'des chiots', NULL, NULL),
(@lr, 'bi nzo - nzo', 'des maisonnettes', NULL, NULL),
(@lr, 'ba ana ngombe', 'des veaux', NULL, 'La forme suivante est correcte et recommandée.'),
(@lr, 'ba ana baa ngombe', 'des veaux ou bien les enfants de la vache', NULL, NULL),
(@lr, '• « - s »', 'pluriel régulier (ex. chien - s → chiens ) ;', NULL, NULL),
(@lr, '• « - x »', 'pluriel en -x (ex. bateau - x → bateaux ) ;', NULL, NULL),
(@lr, 'mu toto', 'la Terre , terre - s', NULL, NULL),
(@lr, 'ma amba', 'eau - x , au sens d''énergie Un autre mot est :', NULL, NULL),
(@lr, 'ma za', 'eau - x , au sens visible', NULL, 'Ce substantif s''emploie toujours au pluriel.'),
(@lr, 'mu pepe - mi pepe', 'air - s', NULL, NULL),
(@lr, 'm bawu', 'feu - x , au sens d''énergie Un autre mot est : tiya = feu - x , au sens visible', NULL, 'Ce substantif s''emploie toujours au pluriel.'),
(@lr, 'mu ludi - mi ludi', 'toit - s', NULL, NULL),
(@lr, 'ki lumbu - bi lumbu', 'jour - s', NULL, NULL);

INSERT INTO examples (lesson_ref_id, kg_text, fr_text, en_text, notes_md)
VALUES
(@lr, 'ki lumbu ki', 'aujourd''hui', NULL, 'Littéralement, cette expression se traduit par : ce jour-ci On peut omettre le préfixe nominal'),
(@lr, 'ki , comme suit : lumbu ki', 'aujourd''hui , etc.', NULL, NULL),
(@lr, 'ma zono ou zono', 'hier', NULL, NULL),
(@lr, 'ma zuzi ou zuzi', 'avant-hier , toute la période plus tôt qu''hier ma zuzi ou zuzi , désignent en réalité, tout le temps avant-hier et plus tôt.', NULL, NULL),
(@lr, 'mbazi', 'demain', NULL, NULL),
(@lr, 'lu mingu - tu mingu', 'semaine - s', NULL, NULL),
(@lr, 'n talu - zi ntalu', 'prix , nombre - s , valeur - s', NULL, NULL),
(@lr, 'n saba - zi nsaba', 'jardin - s', NULL, NULL),
(@lr, 'ki koozo - bi koozo', 'salle - s de bains , toilette - s', NULL, NULL),
(@lr, 'ki kuuku - bi kuuku', 'cuisine - s , foyer - s', NULL, NULL),
(@lr, 'ki mbombo - bi mbombo', 'véranda - s , balcon - s', NULL, NULL),
(@lr, 'n zaaza - zi nzaaza', 'bateau - x', NULL, NULL),
(@lr, 'n gaandu - zi ngaandu', 'crocodile - s , caïman - s', NULL, NULL),
(@lr, 'n deki - zi ndeki', 'avion - s', NULL, NULL),
(@lr, 'mu bu - mi bu', 'mer - s', NULL, NULL),
(@lr, 'm finda - zi mfida', 'forêt - s', NULL, NULL),
(@lr, 'mu ongo - mi ongo', 'montagne - s', NULL, NULL),
(@lr, 'm'' vu - mi vu', 'année - s', NULL, NULL),
(@lr, 'm boma - m boma', 'python - s', NULL, NULL),
(@lr, 'm pidi - m pidi', 'vipère - s', NULL, NULL),
(@lr, 'm pidi - zi mpidi', 'vipère - s', NULL, NULL),
(@lr, 'lu wutuku - tu wutuku', 'généalogie - s', NULL, NULL),
(@lr, 'ki ngoyongo - bi ngoyongo', 'menotte - s , chaîne - s', NULL, NULL),
(@lr, 'lu sikidisu - tu sikidisu', 'diplôme - s , certificat - s , etc.', NULL, NULL),
(@lr, 'n kuala - zi nkuala', 'canal - canaux , chaîne , de radio par exemple', NULL, NULL),
(@lr, 'ki mbila - bi mbila', 'sifflet - s', NULL, NULL),
(@lr, 'n iosi - n iosi', 'abeille - s', NULL, NULL),
(@lr, 'n iosi - zi niosi', 'abeille - s', NULL, NULL),
(@lr, 'di inu - ma inu', 'dent - s', NULL, NULL),
(@lr, 'mu leembo - mi leembo', 'doigt - s', NULL, NULL),
(@lr, 'n siingu - n siingu', 'cou - s', NULL, NULL),
(@lr, 'ki koba - bi koba', 'lèvre - s', NULL, NULL),
(@lr, 'm pivi - m pivi', 'orphelin - s , intrus , genre unique', NULL, NULL),
(@lr, 'di ambu - ma ambu', 'chose - s , affaire - s', NULL, NULL),
(@lr, 'm poofi - zi mpoofi', 'délégué - s , ambassadeur - s , représentant - s', NULL, NULL),
(@lr, 'ki mpuni - bi mpuni', 'imitation - s , fausseté - s , fausse représentation , d''une marque par exemple', NULL, NULL),
(@lr, 'n gika - n gika', 'supplément - s , rajout - s , affixe - s en grammaire', NULL, NULL),
(@lr, 'n gudi - n gudi', 'mère - s , radicale - s , important - s , essentielle - s , réel - s , etc.', NULL, NULL),
(@lr, 'n gudi - zi ngudi', 'mère - s , radicale - s , important - s , essentielle - s , réel - s , etc. Le substantif n talu appartient à la classe n - n .', NULL, 'Sans autre précision, il peut être soit au singulier soit au pluriel. Les deux formulations suivantes sont correctes'),
(@lr, 'n talu - n talu', 'prix , nombre - s , etc.', NULL, NULL),
(@lr, 'n talu - zi ntalu', 'prix , nombre - s , etc.', NULL, NULL),
(@lr, 'mu samu - mi samu', 'affaire - s , problème - s , préoccupation - s m finda étant de la classe n - n , les deux formulations suivantes sont correctes :', NULL, NULL),
(@lr, 'm finda - m finda', 'forêt - s', NULL, NULL),
(@lr, 'm finda - zi mfinda', 'forêt - s', NULL, NULL),
(@lr, 'mu kento - ba kento', 'femme - s', NULL, NULL),
(@lr, 'mu kelo - mi kelo', 'fontaine - s d''eau', NULL, NULL),
(@lr, 'fi ngulu - bi ngulu-ngulu', 'porcelet - s On peut aussi utiliser l''expression mu ana ou', NULL, NULL),
(@lr, 'mu a, comme suit : mu ana ngulu - ba ana ngulu-ngulu', 'porcelet - s', NULL, NULL),
(@lr, 'mu ana a ngulu - ba ana baa ngulu-ngulu', 'porcelet - s', NULL, NULL),
(@lr, 'mu a ngulu - ba ana baa ngulu-ngulu', 'porcelet - s', NULL, NULL);

INSERT INTO examples (lesson_ref_id, kg_text, fr_text, en_text, notes_md)
VALUES
(@lr, 'mu ana - ba ana', 'enfant - s', NULL, NULL),
(@lr, 'ki sielo - bi sielo', 'serviteur - s', NULL, NULL),
(@lr, 'mu lele - mi lele', 'habit - s , tissu - s', NULL, NULL),
(@lr, 'n gudi - zi ngudi', 'mère - s , radicale - s , important - s , essentielle - s , réel - s , etc.', NULL, NULL),
(@lr, 'mu samu - mi samu', 'affaire - s , problème - s , préoccupation - s', NULL, NULL),
(@lr, 'mu ana ngulu - ba ana ngulu-ngulu', 'porcelet - s', NULL, NULL),
(@lr, 'mu kento - ba kento un manguier', '', NULL, NULL),
(@lr, 'mu manga - mi manga un peigne', '', NULL, NULL),
(@lr, 'ki sanu - bi sanu un chiot', '', NULL, NULL),
(@lr, 'fi mbua - bi mbua-mbua un pain', '', NULL, NULL),
(@lr, 'di mpa - ma mpa un voleur', '', NULL, NULL),
(@lr, 'mu yibi - mi yibi une banane', '', NULL, NULL),
(@lr, 'di nkondi - ma nkondi une maisonnette', '', NULL, NULL),
(@lr, 'fi nzo - bi nzo-nzo un œuf', '', NULL, NULL),
(@lr, 'di iki - ma iki une jambe', 'ku ulu - ma alu', NULL, 'Ce substantif au pluriel devrait s''employer'),
(@lr, 'ma ulu. Mais à l''oral, on entend souvent ma alu un chien', '', NULL, NULL),
(@lr, 'm bua - m bua un chien', '', NULL, NULL),
(@lr, 'm bua - zi mbua beau-parent', '', NULL, NULL),
(@lr, 'bu ko - ma ko une demoiselle', '', NULL, NULL),
(@lr, 'fi kento - bi kentokento un ongle', '', NULL, NULL),
(@lr, 'lu zala - zi nzala être humain', '', NULL, NULL),
(@lr, 'mu ntu - ba ntu une petite mangue', 'fi manga - bi mangamanga', NULL, NULL),
(@lr, 'une femme', 'mu kento - ba kento', NULL, NULL),
(@lr, 'un manguier', 'mu manga - mi manga', NULL, NULL),
(@lr, 'un peigne', 'ki sanu - bi sanu', NULL, NULL),
(@lr, 'un chiot', 'fi mbua - bi mbua-mbua', NULL, NULL),
(@lr, 'un pain', 'di mpa - ma mpa', NULL, NULL),
(@lr, 'un voleur', 'mu yibi - mi yibi', NULL, NULL),
(@lr, 'une banane', 'di nkondi - ma nkondi', NULL, NULL),
(@lr, 'une maisonnette', 'fi nzo - bi nzo-nzo', NULL, NULL),
(@lr, 'un œuf', 'di iki - ma iki', NULL, NULL),
(@lr, 'une jambe', 'ku ulu - ma alu', NULL, 'Ce substantif au pluriel devrait s''employer ma ulu. Mais à l''oral, on entend souvent ma alu'),
(@lr, 'un chien', 'm bua - m bua un chien = m bua - zi mbua', NULL, NULL),
(@lr, 'beau-parent', 'bu ko - ma ko', NULL, NULL),
(@lr, 'une demoiselle', 'fi kento - bi kentokento', NULL, NULL),
(@lr, 'un ongle', 'lu zala - zi nzala', NULL, NULL),
(@lr, 'être humain', 'mu ntu - ba ntu', NULL, NULL),
(@lr, 'une petite mangue', 'fi manga - bi mangamanga', NULL, NULL);

-- QC syllabes (CV/CCV/CVV/CCVV)
SELECT a.atom_id, a.normalized_form, st.code AS declared_subtype,
       LOWER(GROUP_CONCAT( CASE WHEN g.grapheme IN ('a','e','i','o','u') THEN 'V' ELSE 'C' END
              ORDER BY ags.seq SEPARATOR '' )) AS derived_subtype,
       GROUP_CONCAT(g.grapheme ORDER BY ags.seq SEPARATOR '') AS grapheme_seq
FROM atoms a
JOIN atom_types t ON t.atom_type_id=a.atom_type_id AND t.code='syllable'
LEFT JOIN atom_subtypes st ON st.atom_subtype_id=a.atom_subtype_id
JOIN atom_grapheme_seq ags ON ags.atom_id=a.atom_id
JOIN graphemes g ON g.grapheme_id=ags.grapheme_id
GROUP BY a.atom_id
HAVING derived_subtype NOT IN ('cv','ccv','cvv','ccvv')
   OR declared_subtype IS NULL
   OR declared_subtype <> derived_subtype;
