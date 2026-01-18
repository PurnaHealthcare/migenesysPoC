import type { DomainEvent } from '../events/domain_events.js';
export interface JourneyReadModel {
    id: string;
    title: string;
    startDate: string;
    status: string;
}
export declare class QueryHandler {
    private journeys;
    project(event: DomainEvent): void;
    getJourneys(): JourneyReadModel[];
}
//# sourceMappingURL=query_handler.d.ts.map