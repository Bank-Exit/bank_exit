> [!IMPORTANT]
> La carte des commerçants du **Collectif Sortie de Banque** permet de trouver des professionnels qui acceptent **Bitcoin**, **Monero** et d'autres monnaies libres dans le monde entier. Le projet repose sur des données ouvertes issues d'OpenStreetMap et s'enrichit grâce aux contributions de la communauté.

<p class="text-center"><%= link_to t("application.header.access_map"), maps_path, class: "btn btn-primary btn-lg" %></p>

Vous cherchez un restaurant, un artisan, un thérapeute, un hébergement ou un commerce qui accepte les paiements en cryptomonnaies ?

[La carte](<%= maps_path %>) du Collectif a été conçue pour faciliter la rencontre entre les utilisateurs de monnaies numériques et les commerçants qui les acceptent. Son objectif est simple : rendre les paiements en Bitcoin et Monero plus accessibles au quotidien.

{{toc}}

[![La carte](<%= image_path(@record.cover) %>)](<%= maps_path %>)

## Que permet la carte ?

La carte répertorie des milliers de commerces à travers le monde et propose plusieurs outils pour trouver rapidement ce que vous cherchez.

Vous pouvez notamment :

- rechercher un commerce par localisation ;
- filtrer les résultats par cryptomonnaie (Bitcoin, Lightning, Monero, June...) ;
- rechercher une catégorie d'activité (restaurant, hôtel, artisan, etc.) ;
- identifier les commerçants qui proposent une livraison ;
- visualiser les établissements qui ne demandent pas de procédure KYC lorsque cette information est disponible.

## Comment utiliser la carte ?

Utiliser la carte est très simple :

1. Ouvrez la carte interactive.
2. Recherchez par nom, adresse ou mots-clés.
3. Appliquez les filtres correspondant à vos besoins.
4. Cliquez sur un commerçant pour consulter sa fiche et les moyens de paiement acceptés.

Vous pouvez ainsi préparer vos achats ou découvrir les commerces proches de chez vous qui acceptent déjà les paiements en cryptomonnaies.

## Vous connaissez un commerçant qui accepte Bitcoin ou Monero ?

La carte est collaborative.

Si vous connaissez un professionnel qui accepte déjà ces moyens de paiement — ou si vous venez d'accompagner un commerçant dans leur mise en place — vous pouvez proposer son ajout directement depuis le bouton <%= link_to "Proposer un commerçant", new_merchant_proposal_path %>.

Après vérification, les informations sont intégrées à OpenStreetMap puis synchronisées automatiquement avec la carte du Collectif.

## Vous êtes commerçant ?

Référencer votre activité permet à de nouveaux clients de vous trouver facilement.

Pour commencer, il suffit généralement de :

- accepter les paiements en Bitcoin ou Monero avec un portefeuille adapté ;
- informer vos clients que ces moyens de paiement sont disponibles ;
- demander votre référencement sur la carte.

Le Collectif met également à disposition des tutoriels, des flyers et des outils de comptabilité pour accompagner les professionnels dans cette démarche.

## Un projet ouvert et communautaire

La carte ne constitue pas un annuaire privé. Les informations proviennent de [OpenStreetMap](https://www.openstreetmap.org), un projet cartographique libre et collaboratif.

Cela signifie que chacun peut contribuer à améliorer les données, signaler un nouveau commerce ou demander la suppression d'une fiche lorsque cela est nécessaire. Les mises à jour sont ensuite synchronisées automatiquement avec la carte du Collectif plusieurs fois par jour.

> [!TIP]
> Plus la communauté contribue, plus il devient facile de trouver des commerces acceptant Bitcoin et Monero. Si vous découvrez un nouvel établissement, pensez à le proposer sur le [formulaire dédié](<%= new_merchant_proposal_path %>) afin d'aider les prochains utilisateurs.

<p class="text-center"><%= link_to t("application.header.access_map"), maps_path, class: "btn btn-primary btn-lg" %></p>
