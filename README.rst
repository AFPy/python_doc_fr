Traduction française de docs.python.org
=======================================

Ce projet vise à mettre à disposition sur le site de l'afpy une
`traduction en français <http://www.afpy.org/doc/python/>`_ de la
documentation officielle de Python.

Votre aide est la bienvenue que ce soit pour maintenir les traductions
à jour, les relire, les améliorer ou traduire de nouveaux blocs.

Comment qu'on fait pour aider à traduire ?
------------------------------------------

Pour cela récupérez les fichiers *.po* de la partie qui vous intéresse,
d'une des façons suivantes:

* forkez ce dépôt
* cliquez sur l'icone "Download ZIP"

Éditer les fichiers avec l'éditeur de votre choix, il en existe beaucoup:

* Le classique: <http://www.poedit.net/>`_
* gted
* gtranslator
* lokalize
* betterpoeditor
* vim ou emacs avec un mode PO
* Vé sur Android
* Probablement d'autres :)

Puis vous n'avez plus qu'à vous occuper du texte en français.

Une fois votre contribution écrite, transmettez-la nous :

* soit par un pull-request (si vous avez fait un fork)
* soit en la joignant à un `ticket github<https://github.com/AFPy/python_doc_fr/issues>`
* soit par mail à la `liste traductions <http://lists.afpy.org/mailman/listinfo/traductions>`_

Norme
-----

Si vous utilisez git et faites des pull requests, cette section est
importante, pour les mails et les tickets, on s'en occupera pur vous.

Afin de ne pas générer des diff illisibles remplis de plus de
différences de norme que de différences de texte, autremment dit, afin
d'obtenir un historique git lisible, et des merge faciles, nous
devrions tous utiliser strictement la même norme.

Actuellement, nous utilisons la norme proposée par *msgcat*, vous
pouvez donc utiliser cette ligne pour remettre vos traductions en forme:

    for po in *.po; do echo $po; tac $po | tac | msgcat - -o $po; done

(L'astuce tac|tac c'est pour lire entièrement le fichier avant de
l'écrire).

Quelles sont les priorités ?
----------------------------
La quantité de textes à traduire est énorme et il serait très facile de
disperser notre énergie dans des textes destinés aux utilisateurs très avancés,
il nous paraît nécessaire de fixer des priorités:

1. Avant tout et surtout : maintenir les textes déjà complets (tutorial.po).
2. le glossaire (glossary.po)
3. les bases du langage (reference.po)
4. la notice d'installation de Python (using.po)
5. la foire aux questions (faq.po)

Aides à la traduction
---------------------

* Si vous hésitez sur un terme, demandez un avis sur la
  `liste traductions <http://lists.afpy.org/mailman/listinfo/traductions>`_.
* Vous pouvez consulter le `glossaire traduc.org <http://glossaire.traduc.org>`_
  qui contient des traductions consolidées de plusieur projets.
* Consultez aussi le site de `traduc.org <http://traduc.org>`_
  qui contient de nombreuses informations pour les traducteurs.
* `Le grand dictionnaire terminologique` <http://gdt.oqlf.gouv.qc.ca/>`_
* glossary.po tout simplement, ou `le glossaire traduit <http://www.afpy.org/doc/python/3.4/glossary.html>`_

Uniformisation du vocabulaire
-----------------------------

Afin d'obtenir un document cohérent cette section propose une
traduction de quelques termes techniques, rappelant ainsi les
anglicismes à éviter, ce n'est qu'une proposition discutable (ouvrez
un ticket si vous n'êtes pas d'acord) :

 * -like => -compaticle (Pas toujours élégant)
 * abstract data type => type abstrait
 * argument => argument (et non paramètre (qui est la traduction de parameter))
 * backslash => antislash
 * bound => lier
 * bug => bug (Bogue étant déjà pris par la châtaigne...)
 * débugging => débogage (en contradiction avec le précédent ?)
 * built-in => primitives, interne
 * double quote => guillemet
 * identifier => identifiant
 * immutable => immuable
 * interpreter => interpréteur
 * library => bibliothèque
 * list compréhension => compréhension de liste
 * little/big endian => `petit-boutiste et gros-boutiste <https://fr.wikipedia.org/wiki/Les_Voyages_de_Gulliver#Voyage_.C3.A0_Lilliput>`_
 * mutable => variable
 * parameter => paramètre
 * prompt => invite
 * regular expression => expression rationelle
 * simple quote => guillemet simple
 * socket => socket ("Je veux mon niveau ! Chausette ! Chausette !")
 * statement => instruction
 * underscore => tiret bas

Comment ça marche ?
-------------------

Tout peut être amené à bouger, mais pour le moment, voilà l'état des choses:

 - Il n'y à pas (plus) de cron sur afpy.org ni ailleurs.
 - ``pip3 install --user -U -r requirements.txt`` vous installera *sphinx*
 - ``sync.sh`` nous permet de mettre à jour les *msgid* dans les *.po*
 - ``build.sh`` génère une version HTML locale de la doc
 - Le résultat de ``build.sh`` peut être ``rsync`` sur afpy.org, tout simplement.
