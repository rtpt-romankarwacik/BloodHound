-- Copyright 2025 Specter Ops, Inc.
--
-- Licensed under the Apache License, Version 2.0
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- SPDX-License-Identifier: Apache-2.0

-- OpenGraph Search feature flag
INSERT INTO feature_flags (created_at, updated_at, key, name, description, enabled, user_updatable)
VALUES (current_timestamp,
    current_timestamp,
    'opengraph_search',
    'OpenGraph Search',
    'Enable OpenGraph Search',
    false,
    false)
ON CONFLICT DO NOTHING;


-- OpenGraph graph schema - extensions (collectors)
CREATE TABLE IF NOT EXISTS schema_extensions (
    id SERIAL NOT NULL,
    name TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL,
    version TEXT NOT NULL,
    is_builtin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
    deleted_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    PRIMARY KEY (id)
);


-- Individual findings. ie T0WriteOwner, T0ADCSESC1, T0DCSync
CREATE TABLE IF NOT EXISTS schema_relationship_findings (
    id serial not null,
    extension_id integer not null,
    relationship_kind_id integer,
    environment_id integer not null,

    name text not null,
    display_name text not null,
    created_at timestamp with time zone default current_timestamp,
    primary key (id),
    unique(name)
);

-- Remediation content table with FK to findings
CREATE TABLE IF NOT EXISTS schema_remediations (
    id SERIAL PRIMARY KEY,
    finding_id INTEGER NOT NULL,
    short_description TEXT,
    long_description TEXT,
    short_remediation TEXT,
    long_remediation TEXT,
    CONSTRAINT unique_finding_remediation UNIQUE (finding_id)
);

CREATE TABLE schema_environments (
    id SERIAL PRIMARY KEY,
    extension_id INTEGER NOT NULL,
    environment_kind_id INTEGER NOT NULL,
    source_kind_id INTEGER NOT NULL,
    unique(extension_id,environment_kind_id,source_kind_id)
  );
