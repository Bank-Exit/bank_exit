> [!IMPORTANT]
> The **Bank-Exit Collective** merchant map helps you find businesses around the world that accept **Bitcoin**, **Monero**, and other free and decentralized currencies. The project is built on open data from OpenStreetMap and continuously grows thanks to community contributions.

<p class="text-center"><%= link_to t("application.header.access_map"), maps_path, class: "btn btn-primary btn-lg" %></p>

Looking for a restaurant, craftsman, therapist, accommodation, or local business that accepts cryptocurrency payments?

The Collective's [merchant map](<%= maps_path %>) was created to connect cryptocurrency users with businesses that accept digital currencies. Its goal is simple: to make everyday Bitcoin and Monero payments easier and more accessible.

{{toc}}

[![Map illustration](<%= image_path(@record.cover) %>)](<%= maps_path %>)

## What can you do with the map?

The map lists thousands of businesses worldwide and includes several tools to help you quickly find what you're looking for.

You can:

- search for businesses by location;
- filter results by cryptocurrency (Bitcoin, Lightning, Monero, June, etc.);
- browse by business category (restaurants, hotels, artisans, and more);
- identify businesses that offer delivery;
- see which businesses do not require KYC when this information is available.

## How do you use the map?

Getting started is easy:

1. Open the interactive map.
2. Search by name, address, or keywords.
3. Apply the filters that match your needs.
4. Click on a business to view its details and accepted payment methods.

Whether you're planning a trip or simply exploring your local area, the map makes it easy to discover businesses that already accept cryptocurrency payments.

## Do you know a business that accepts Bitcoin or Monero?

The map is community-driven.

If you know a business that already accepts these payment methods—or you've recently helped a merchant start accepting them—you can submit it directly using the <%= link_to "Suggest a merchant", new_merchant_proposal_path %> button.

Once verified, the information is added to OpenStreetMap and automatically synchronized with the Collective's map.

## Are you a merchant?

Listing your business helps new customers discover you.

Getting started is usually as simple as:

- accepting Bitcoin or Monero payments with a compatible wallet;
- letting your customers know these payment methods are available;
- requesting to have your business added to the map.

The Collective also provides tutorials, flyers, and accounting resources to help merchants adopt cryptocurrency payments.

## An open, community-driven project

The map is not a private directory. Its data comes from [OpenStreetMap](https://www.openstreetmap.org), a free and collaborative mapping project.

Anyone can contribute by improving existing data, adding new businesses, or requesting the removal of outdated listings when necessary. Updates are automatically synchronized with the Collective's map several times a day.

> [!TIP]
> The more the community contributes, the easier it becomes to find businesses accepting Bitcoin and Monero. If you discover a new business, consider submitting it through the [dedicated form](<%= new_merchant_proposal_path %>) to help future users.

<p class="text-center"><%= link_to t("application.header.access_map"), maps_path, class: "btn btn-primary btn-lg" %></p>
